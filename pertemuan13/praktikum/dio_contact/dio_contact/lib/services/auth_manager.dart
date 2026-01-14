import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthManager {
  static const String _loginStatusKey = 'login_status';
  static const String _loginTimeKey = 'login_time';
  static const String _usernameKey = 'username';
  static const String _tokenKey = 'token';

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();

    final bool isLoggedIn = prefs.getBool(_loginStatusKey) ?? false;
    final String? loginTimeString = prefs.getString(_loginTimeKey);

    if (isLoggedIn && loginTimeString != null) {
      try {
        final DateTime loginTime = DateTime.parse(loginTimeString);
        final Duration timeDifference =
            DateTime.now().difference(loginTime);

        const Duration maxDuration = Duration(hours: 4);

        if (timeDifference > maxDuration) {
          await logout();
          return false;
        }
        return true;
      } catch (e) {
        debugPrint('Error parsing DateTime: $e');
        await logout();
        return false;
      }
    }
    return false;
  }

  static Future<void> login(String username, String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loginStatusKey, true);
    await prefs.setString(_loginTimeKey, DateTime.now().toIso8601String());
    await prefs.setString(_usernameKey, username);
    await prefs.setString(_tokenKey, token);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }
}

import 'package:dio/dio.dart';
import 'user.dart';
import 'package:flutter/foundation.dart';

class DataService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://reqres.in/api', 
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'x-api-key': 'reqres_bbca121c38f748198e21e44314b34e2b',
      },
    ),
  );

  Future getUsers() async {
    try {
      final res = await _dio.get('/users');
      debugPrint('STATUS GET: ${res.statusCode}');
      debugPrint('DATA GET: ${res.data}');
      return res.data;
    } catch (e) {
      debugPrint('ERROR GET: $e');
      return null;
    }
  }


  Future<UserCreate?> postUser(UserCreate user) async {
    try {
      final response = await _dio.post('/users', data: user.toMap());

      debugPrint('STATUS POST: ${response.statusCode}');
      debugPrint('DATA POST: ${response.data}');

      if (response.statusCode == 201) {
        return UserCreate.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      debugPrint('DIO ERROR POST: ${e.response?.statusCode}');
      return null;
    } catch (e) {
      debugPrint('ERROR POST: $e');
      return null;
    }
  }


  Future<Map<String, dynamic>?> putUser(String idUser, String name, String job) async {
    try {
      final response = await _dio.put( 
        '/users/$idUser',
        data: {'name': name, 'job': job},
      );

      debugPrint('STATUS PUT: ${response.statusCode}');
      debugPrint('DATA PUT: ${response.data}');

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        return response.data;
      }
      return null;
    } on DioException catch (e) {
      debugPrint('DIO ERROR PUT: ${e.response?.statusCode}');
      debugPrint('DIO ERROR DATA: ${e.response?.data}');
      return null;
    } catch (e) {
      debugPrint('ERROR PUT: $e');
      return null;
    }
  }


  Future deleteUser(String idUser) async {
    try {
      final response = await _dio.delete('/users/$idUser');
      debugPrint('STATUS DELETE: ${response.statusCode}');
      return response.statusCode == 204 ? 'Delete user success' : null;
    } on DioException catch (e) {
      debugPrint('DIO ERROR DELETE: ${e.response?.statusCode}');
      return null;
    } catch (e) {
      debugPrint('ERROR DELETE: $e');
      return null;
    }
  }


  Future<Iterable<User>?> getUserModel() async {
    try {
      final response = await _dio.get('/users');
      if (response.statusCode == 200) {
        final users = (response.data['data'] as List)
            .map((user) => User.fromJson(user))
            .toList();
        return users;
      }
      return null;
    } catch (e) {
      debugPrint('ERROR GET MODEL: $e');
      rethrow;
    }
  }
}
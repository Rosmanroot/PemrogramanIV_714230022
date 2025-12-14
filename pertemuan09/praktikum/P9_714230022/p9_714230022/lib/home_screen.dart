import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  // Key yang digunakan di LoginScreen untuk status Remember Me
  static const String _rememberMeCheckedKey = 'isRememberMeChecked';
  static const String _rememberUsernameKey = 'rememberUsername';

  late SharedPreferences logindata;
  String username = "";

  void initial() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      // Mengambil username yang digunakan untuk tampilan Home
      username = logindata.getString('username').toString();
    });
  }

  @override
  void initState() {
    super.initState();
    initial();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16,
          ),
          child: Column(
            children: [
              const Text('Welcome to Home'),
              const SizedBox(height: 20),
              Text(username),
              ElevatedButton(
                onPressed: () {
                  // Saat pengguna logout, username tetap tersimpan jika Remember Me aktif
                  bool isRememberMeActive =
                      logindata.getBool(_rememberMeCheckedKey) ?? false;

                  logindata.setBool('login', true); // status login (logout)
                  logindata.remove('username'); // hapus username aktif

                  if (!isRememberMeActive) {
                    // Jika Remember Me tidak aktif, hapus username yang diingat
                    logindata.remove(_rememberUsernameKey);
                  }

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

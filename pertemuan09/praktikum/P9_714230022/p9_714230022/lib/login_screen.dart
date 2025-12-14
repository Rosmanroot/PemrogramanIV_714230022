import 'package:flutter/material.dart';
import 'package:p9_714230022/botnav.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  late SharedPreferences loginData;
  late bool newUser;

  // Fitur Remember Me
  bool _rememberMe = false;
  static const String _rememberUsernameKey = 'rememberUsername';
  static const String _rememberMeCheckedKey = 'isRememberMeChecked';

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateUsername(String? value) {
    if (value != null && value.length < 4) {
      return 'Masukkan minimal 4 karakter';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value != null && value.length < 3) {
      return 'Masukkan minimal 3 karakter';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    // Inisialisasi SharedPreferences
    checkLogin();
  }

  void checkLogin() async {
    loginData = await SharedPreferences.getInstance();
    newUser = loginData.getBool('login') ?? true;

    // Panggil fungsi untuk memuat username setelah loginData siap
    _loadRememberedUsername();

    if (newUser == false) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => DynamicBottomNavBar(),
          ),
          (route) => false);
    }
  }
  
  // Fungsi untuk memuat username yang disimpan (Poin 2.c)
  void _loadRememberedUsername() {
    final rememberedUsername = loginData.getString(_rememberUsernameKey);
    final lastRememberState = loginData.getBool(_rememberMeCheckedKey) ?? false;

    if (rememberedUsername != null && lastRememberState) {
        // Jika ada username yang tersimpan dan Remember Me dicentang,
        // isi otomatis field username
        _usernameController.text = rememberedUsername;
        // Set status checkbox
        setState(() {
          _rememberMe = lastRememberState;
        });
    } else {
        // Jika tidak dicentang atau tidak ada data, pastikan state checkbox false
        setState(() {
          _rememberMe = false;
        });
    }
  }

  // Fungsi untuk menyimpan username (Poin 2.a)
  void _saveRememberedUsername(String username) {
    loginData.setString(_rememberUsernameKey, username);
    loginData.setBool(_rememberMeCheckedKey, true);
  }

  // Fungsi untuk menghapus username yang disimpan (Poin 3.a)
  void _removeRememberedUsername() {
    loginData.remove(_rememberUsernameKey);
    loginData.setBool(_rememberMeCheckedKey, false);
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Shared Preference')),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: _validateUsername,
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.account_circle_rounded),
                        hintText: 'Write username here...',
                        labelText: 'Username',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        fillColor: Color.fromARGB(255, 242, 254, 255),
                        filled: true,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      obscureText: true,
                      validator: _validatePassword,
                      controller: _passwordController, // Pastikan controller terpasang ke password
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.password_rounded),
                        hintText: 'Write your password here...',
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        fillColor: Color.fromARGB(255, 242, 254, 255),
                        filled: true,
                      ),
                    ),
                  ),
                  // 1. Tambahkan Checkbox "Remember Me"
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (bool? newValue) {
                            setState(() {
                              _rememberMe = newValue!;
                            });
                            // Simpan status terakhir checkbox
                            loginData.setBool(_rememberMeCheckedKey, _rememberMe);
                            
                            // 3. Jika checkbox tidak dicentang, hapus username (jika sebelumnya ada)
                            if (!_rememberMe) {
                              _removeRememberedUsername();
                            }
                          },
                        ),
                        const Text('Remember Me'),
                      ],
                    ),
                  ),
                  // Tombol Login
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        final isValidForm = _formKey.currentState!.validate();

                        String username = _usernameController.text;
                        if (isValidForm) {
                          
                          if (_rememberMe) {
                            // 2.a. Jika checkbox dicentang, simpan username
                            _saveRememberedUsername(username);
                          } else {
                            // 3.a. Jika checkbox tidak dicentang, hapus username
                            _removeRememberedUsername();
                          }
                          
                          loginData.setBool('login', false);
                          loginData.setString('username', username);
                          
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DynamicBottomNavBar(),
                            ),
                            (route) => false,
                          );
                        }
                      },
                      child: const Text('Login'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
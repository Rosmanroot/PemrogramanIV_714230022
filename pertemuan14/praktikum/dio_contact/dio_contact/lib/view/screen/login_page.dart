import 'package:flutter/material.dart';
import 'package:dio_contact/model/login_model.dart';
import '../../services/api_services.dart';
import '../../services/auth_manager.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiServices _dataService = ApiServices();

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    final isLoggedIn = await AuthManager.isLoggedIn();
    if (isLoggedIn && mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
        (_) => false,
      );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateUsername(String? value) {
    if (value == null || value.length < 4) {
      return 'Masukkan minimal 4 karakter';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.length < 3) {
      return 'Masukkan minimal 3 karakter';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildUsernameField(),
              const SizedBox(height: 16),
              _buildPasswordField(),
              const SizedBox(height: 24),
              _buildLoginButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUsernameField() {
    return TextFormField(
      controller: _usernameController,
      validator: _validateUsername,
      decoration: const InputDecoration(
        labelText: 'Username',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      validator: _validatePassword,
      obscureText: true,
      decoration: const InputDecoration(
        labelText: 'Password',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            final input = LoginInput(
              username: _usernameController.text,
              password: _passwordController.text,
            );

            final LoginResponse? res = await _dataService.login(input);

            if (res == null) {
              displaySnackbar('Response null');
              return;
            }

            if (res.status != 200) {
              displaySnackbar(res.message);
              return;
            }

            final String token = res.token ?? '';

            if (token.isEmpty) {
              displaySnackbar('Token tidak ditemukan');
              return;
            }

            await AuthManager.login(_usernameController.text, token);

            if (!mounted) return;
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
              (_) => false,
            );
          }
        },
        child: const Text('Login'),
      ),
    );
  }

  void displaySnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }
}

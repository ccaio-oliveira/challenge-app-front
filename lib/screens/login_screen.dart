import 'package:challenge_app_flutter/screens/challenge_list_screen.dart';
import 'package:challenge_app_flutter/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  bool _isLoading = false;
  String? _errorMessage;

  bool _validateFields() {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor, preencha todos os campos.';
      });
      return false;
    }

    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
    if (!emailRegex.hasMatch(email)) {
      setState(() {
        _errorMessage = 'Por favor, insira um e-mail válido.';
      });
      return false;
    }

    if (password.length < 6) {
      setState(() {
        _errorMessage = 'A senha deve ter pelo menos 6 caracteres.';
      });
      return false;
    }

    setState(() {
      _errorMessage = null;
    });

    return true;
  }

  void _login() async {
    if (!_validateFields()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');

      final result = await _authService.login(
        _emailController.text,
        _passwordController.text,
      );

      final token = result['access_token'];
      await prefs.setString('auth_token', token);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login realizado com sucesso!')));

      await Future.delayed(Duration(milliseconds: 500));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ChallengeListScreen()),
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'E-mail ou senha inválidos';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Entrar')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'E-mail'),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            if (_errorMessage != null)
              Text(_errorMessage!, style: TextStyle(color: Colors.red)),
            SizedBox(height: 16),
            _isLoading
                ? CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _login,
                      child: Text('Entrar'),
                    ),
                  ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignupScreen()),
                );
              },
              child: Text('Não tem uma conta? Cadastre-se'),
            ),
          ],
        ),
      ),
    );
  }
}

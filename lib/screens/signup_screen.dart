import 'package:challenge_app_flutter/services/auth_service.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  bool _validateFields() {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Todos os campos são obrigatórios';
      });
      return false;
    }

    final emailRegex = RegExp(r'^[\W\.-]+@[\w\.-]+@[\w\.-]+\.\w+$');
    if (!emailRegex.hasMatch(email)) {
      setState(() {
        _errorMessage = 'Informe um e-mail válido';
      });
      return false;
    }

    if (password.length < 6) {
      setState(() {
        _errorMessage = 'A senha deve ter pelo menos 6 caracteres';
      });
      return false;
    }

    setState(() {
      _errorMessage = null;
    });

    return true;
  }

  void _signup() async {
    if (!_validateFields()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      await _authService.register(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
      );

      setState(() {
        _successMessage =
            'Cadastro realizado com sucesso! Faça login para continuar.';
      });

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao cadastrar. Tente outro e-mail.';
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
      appBar: AppBar(title: Text('Cadastrar')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nome'),
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'E-mail'),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _signup(),
            ),
            SizedBox(height: 16),
            if (_errorMessage != null)
              Text(_errorMessage!, style: TextStyle(color: Colors.red)),
            if (_successMessage != null)
              Text(_successMessage!, style: TextStyle(color: Colors.green)),
            SizedBox(height: 16),
            _isLoading
                ? CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _signup,
                      child: Text('Cadastrar'),
                    ),
                  ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Já tem uma conta? Faça login'),
            ),
          ],
        ),
      ),
    );
  }
}

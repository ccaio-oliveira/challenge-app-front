import 'package:challenge_app_flutter/services/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';

class MockAuthService extends AuthService {
  bool _shouldLoginSucceed = true;
  bool _shouldRegisterSucceed = true;
  String _mockToken = 'mock_token_123';
  Exception? _mockException;

  void setLoginSuccess(bool success, {String token = 'mock_token_123'}) {
    _shouldLoginSucceed = success;
    _mockToken = token;
  }

  void setRegisterSuccess(bool success) {
    _shouldRegisterSucceed = success;
  }

  void setMockException(Exception exception) {
    _mockException = exception;
  }

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    await Future.delayed(Duration(milliseconds: 100)); // Simula delay da rede
    
    if (_mockException != null) {
      throw _mockException!;
    }
    
    if (_shouldLoginSucceed) {
      return {'access_token': _mockToken};
    } else {
      throw Exception('Login inválido');
    }
  }

  @override
  Future<void> register(String name, String email, String password) async {
    await Future.delayed(Duration(milliseconds: 100)); // Simula delay da rede
    
    if (_mockException != null) {
      throw _mockException!;
    }
    
    if (!_shouldRegisterSucceed) {
      throw Exception('Erro ao registrar usuário');
    }
  }
}
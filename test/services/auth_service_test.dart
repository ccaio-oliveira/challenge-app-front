import 'dart:convert';

import 'package:challenge_app_flutter/services/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;

void main() {
  group('AuthService', () {
    late AuthService authService;

    setUp(() {
      authService = AuthService();
    });

    group('login', () {
      test('returns token on success', () async {
        authService.httpClient = MockClient((request) async {
          expect(request.url.toString(), 'http://localhost:3000/auth/login');
          expect(request.method, 'POST');
          // Mudança aqui: usar contains ao invés de igualdade exata
          expect(request.headers['Content-Type'], contains('application/json'));

          final body = jsonDecode(request.body);
          expect(body['email'], 'test@test.com');
          expect(body['password'], 'password123');

          return http.Response(jsonEncode({'access_token': 'token123'}), 200);
        });

        final result = await authService.login('test@test.com', 'password123');
        expect(result['access_token'], 'token123');
      });

      test('returns token on 201 status code', () async {
        authService.httpClient = MockClient((request) async {
          return http.Response(jsonEncode({'access_token': 'token456'}), 201);
        });

        final result = await authService.login('test@test.com', 'password123');
        expect(result['access_token'], 'token456');
      });

      test('throws exception on 401 error', () async {
        authService.httpClient = MockClient((request) async {
          return http.Response('Unauthorized', 401);
        });

        expect(
          () => authService.login('wrong@email.com', 'wrongpassword'),
          throwsException,
        );
      });

      test('throws exception on 400 error', () async {
        authService.httpClient = MockClient((request) async {
          return http.Response('Bad Request', 400);
        });

        expect(
          () => authService.login('invalid@email.com', 'pass'),
          throwsException,
        );
      });
    });

    group('register', () {
      test('completes successfully on 201 status code', () async {
        authService.httpClient = MockClient((request) async {
          expect(request.url.toString(), 'http://localhost:3000/users');
          expect(request.method, 'POST');
          // Mudança aqui: usar contains ao invés de igualdade exata
          expect(request.headers['Content-Type'], contains('application/json'));

          final body = jsonDecode(request.body);
          expect(body['name'], 'João Silva');
          expect(body['email'], 'joao@test.com');
          expect(body['password'], 'password123');

          return http.Response('', 201);
        });

        await authService.register('João Silva', 'joao@test.com', 'password123');
        // Teste passa se não lançar exceção
      });

      test('completes successfully on 200 status code', () async {
        authService.httpClient = MockClient((request) async {
          return http.Response('', 200);
        });

        await authService.register('Maria Silva', 'maria@test.com', 'password123');
        // Teste passa se não lançar exceção
      });

      test('throws exception on 400 error', () async {
        authService.httpClient = MockClient((request) async {
          return http.Response('Email already exists', 400);
        });

        expect(
          () => authService.register('João Silva', 'existing@test.com', 'password123'),
          throwsException,
        );
      });

      test('throws exception on 500 error', () async {
        authService.httpClient = MockClient((request) async {
          return http.Response('Internal Server Error', 500);
        });

        expect(
          () => authService.register('João Silva', 'joao@test.com', 'password123'),
          throwsException,
        );
      });
    });
  });
}

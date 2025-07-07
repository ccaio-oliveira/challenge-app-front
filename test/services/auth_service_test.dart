import 'dart:convert';

import 'package:challenge_app_flutter/services/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;

void main() {
  test('Login returns token on success', () async {
    final service = AuthService();
    service.httpClient = MockClient((request) async {
      return http.Response(jsonEncode({'access_token': 'token123'}), 200);
    });

    final result = await service.login('a@a.com', 'pw');
    expect(result['access_token'], 'token123');
  });

  test('Login throws exception on error', () async {
    final service = AuthService();
    service.httpClient = MockClient((request) async {
      return http.Response('Unauthorized', 401);
    });

    expect(() => service.login('a@a.com', 'pw'), throwsException);
  });
}

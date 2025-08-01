import 'dart:convert';

import 'package:challenge_app_flutter/models/challenge.dart';
import 'package:challenge_app_flutter/models/task_input.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000';

  // Method to check if user is authenticated
  Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    return token != null && token.isNotEmpty;
  }

  // Method to get the stored token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Method to clear the stored token
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  Future<List<Challenge>> fetchChallenges() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null || token.isEmpty) {
      throw Exception('Usuário não autenticado');
    }

    final url = Uri.parse('$baseUrl/challenges');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => Challenge.fromJson(e)).toList();
      } else if (response.statusCode == 401) {
        await prefs.remove('auth_token');
        throw Exception('Sessão expirada. Faça login novamente.');
      } else {
        throw Exception(
          'Erro ao buscar desafios (${response.statusCode}): ${response.body}',
        );
      }
    } catch (e) {
      if (e.toString().contains('Sessão expirada')) {
        rethrow;
      }
      throw Exception('Erro de conexão: $e');
    }
  }

  Future<int> createChallenge(
    String title,
    String description,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null || token.isEmpty) {
      throw Exception('Usuário não autenticado');
    }

    final url = Uri.parse('$baseUrl/challenges');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'title': title,
        'description': description,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['id'];
    } else if (response.statusCode == 401) {
      await prefs.remove('auth_token');
      throw Exception('Sessão expirada. Faça login novamente.');
    } else {
      print('Erro backend: ${response.body}');
      throw Exception(
        'Erro ao criar desafio (${response.statusCode}): ${response.body}',
      );
    }
  }

  Future<void> addTaskToChallenge({
    required int challengeId,
    required TaskInput task,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null) throw Exception('Usuário não autenticado');
    final url = Uri.parse('$baseUrl/challenges/$challengeId/tasks');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'title': task.title,
        'description': task.description,
        'recurrenceType': task.recurrenceType,
        'recurrenceData': task.recurrenceData,
        'requiredPhoto': task.requiredPhoto,
      }),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Erro ao adicionar task: ${response.body}');
    }
  }
}

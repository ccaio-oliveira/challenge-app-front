import 'package:challenge_app_flutter/models/challenge.dart';
import 'package:challenge_app_flutter/screens/login_screen.dart';
import 'package:challenge_app_flutter/services/api_service.dart';
import 'package:flutter/material.dart';

class ChallengeListScreen extends StatefulWidget {
  const ChallengeListScreen({Key? key}) : super(key: key);

  @override
  State<ChallengeListScreen> createState() => _ChallengeListScreenState();
}

class _ChallengeListScreenState extends State<ChallengeListScreen> {
  late Future<List<Challenge>> _futureChallenges;

  @override
  void initState() {
    super.initState();
    _loadChallenges();
  }

  void _loadChallenges() async {
    final apiService = ApiService();

    final isAuth = await apiService.isAuthenticated();

    if (!isAuth) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      });
      return;
    }

    setState(() {
      _futureChallenges = apiService.fetchChallenges();
    });
  }

  void _reloadChallenges() {
    _loadChallenges();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Desafios'),
        actions: [
          IconButton(
            onPressed: () async {
              final apiService = ApiService();
              await apiService.clearToken();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: FutureBuilder<List<Challenge>>(
        future: _futureChallenges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            final error = snapshot.error.toString();

            if (error.contains('Sessão expirada') ||
                error.contains('não autenticado')) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              });
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Erro ao carregar desafios: ${snapshot.error}'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _reloadChallenges,
                    child: Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          final challenges = snapshot.data ?? [];
          if (challenges.isEmpty) {
            return Center(child: Text('Nenhum desafio encontrado.'));
          }

          return ListView.builder(
            itemCount: challenges.length,
            itemBuilder: (context, index) {
              final c = challenges[index];
              return ListTile(
                title: Text(c.title),
                subtitle: Text(c.description),
                trailing: Text(
                  '${c.createdAt.day}/${c.createdAt.month}/${c.createdAt.year}',
                  style: TextStyle(fontSize: 12),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

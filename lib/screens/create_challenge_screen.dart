import 'package:challenge_app_flutter/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CreateChallengeScreen extends StatefulWidget {
  final VoidCallback? onChallengeCreated;

  const CreateChallengeScreen({Key? key, this.onChallengeCreated})
    : super(key: key);

  @override
  State<CreateChallengeScreen> createState() => _CreateChallengeScreenState();
}

class _CreateChallengeScreenState extends State<CreateChallengeScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;
  String? _error;
  String? _success;

  void _createChallenge() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _success = null;
    });

    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      setState(() {
        _isLoading = false;
        _error = 'Preencha todos os campos.';
      });
      return;
    }

    try {
      final create = await ApiService().createChallenge(
        _titleController.text.trim(),
        _descriptionController.text.trim(),
      );

      if (create) {
        setState(() {
          _success = 'Desafio criado com sucesso!';
          _titleController.clear();
          _descriptionController.clear();
        });

        if (widget.onChallengeCreated != null) {
          widget.onChallengeCreated!();
        }

        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pop();
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString().replaceAll('Exception', '').trim();
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
      appBar: AppBar(title: Text('Novo Desafio')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Título'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Descrição'),
              minLines: 2,
              maxLines: 5,
            ),
            SizedBox(height: 16),
            if (_error != null)
              Text(_error!, style: TextStyle(color: Colors.red)),
            if (_success != null)
              Text(_success!, style: TextStyle(color: Colors.green)),
            SizedBox(height: 16),
            _isLoading
                ? CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _createChallenge,
                      child: Text('Criar Desafio'),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

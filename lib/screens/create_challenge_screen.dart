import 'package:challenge_app_flutter/models/task_input.dart';
import 'package:challenge_app_flutter/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

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
  DateTime? _startDate;
  DateTime? _endDate;

  final List<TaskInput> _tasks = [];
  bool _isLoading = false;
  String? _error;
  String? _success;

  final _taskFormKey = GlobalKey<FormState>();
  final _taskTitleController = TextEditingController();
  final _taskDescriptionController = TextEditingController();
  String _recurrenceType = 'daily';
  String _recurrenceData = '';
  bool _requiredPhoto = false;

  String _formatDate(DateTime? date) =>
      date == null ? 'Selecione' : DateFormat('dd/MM/yyyy').format(date);

  void _addTask() {
    if (_taskTitleController.text.isEmpty) return;
    setState(() {
      _tasks.add(
        TaskInput(
          title: _taskTitleController.text,
          description: _taskDescriptionController.text,
          recurrenceType: _recurrenceType,
          recurrenceData: _recurrenceData.isNotEmpty ? _recurrenceData : null,
          requiredPhoto: _requiredPhoto,
        ),
      );

      _taskTitleController.clear();
      _taskDescriptionController.clear();
      _recurrenceType = 'daily';
      _recurrenceData = '';
      _requiredPhoto = false;
    });
    Navigator.pop(context);
  }

  void _openAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Adicionar Tarefa'),
          content: SingleChildScrollView(
            child: Form(
              key: _taskFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _taskTitleController,
                    decoration: InputDecoration(labelText: 'Título da tarefa'),
                    validator: (val) => val == null || val.isEmpty
                        ? 'Título é obrigatório'
                        : null,
                  ),
                  TextFormField(
                    controller: _taskDescriptionController,
                    decoration: InputDecoration(labelText: 'Descrição'),
                    validator: (val) => val == null || val.isEmpty
                        ? 'Descrição é obrigatória'
                        : null,
                  ),
                  DropdownButtonFormField(
                    value: _recurrenceType,
                    items: [
                      DropdownMenuItem(value: 'daily', child: Text('Diária')),
                      DropdownMenuItem(value: 'weekly', child: Text('Semanal')),
                      DropdownMenuItem(
                        value: 'specific_dates',
                        child: Text('Datas Específicas'),
                      ),
                      DropdownMenuItem(
                        value: 'weekends',
                        child: Text('Finais de Semana'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _recurrenceType = value!;
                      });
                    },
                    decoration: InputDecoration(labelText: 'Recorrência'),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText:
                          'Dias da semana/Datas (ex: 1,3,5 ou 2025-08-01)',
                    ),
                    onChanged: (val) => _recurrenceData = val,
                    validator: (val) {
                      if (_recurrenceType == 'specific_dates' && val!.isEmpty) {
                        return 'Datas específicas são obrigatórias';
                      }
                      return null;
                    },
                  ),
                  CheckboxListTile(
                    value: _requiredPhoto,
                    title: Text('Exigir foto?'),
                    onChanged: (val) {
                      setState(() {
                        _requiredPhoto = val ?? false;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_taskFormKey.currentState?.validate() ?? false) {
                  _addTask();
                }
              },
              child: Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  Future<void> _saveChallenge() async {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _startDate == null ||
        _endDate == null ||
        _tasks.isEmpty) {
      setState(() {
        _error = 'Preencha todos os campos e adicione pelo menos uma tarefa.';
        _success = null;
      });
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _success = null;
    });

    try {
      int challengeId = await ApiService().createChallenge(
        _titleController.text.trim(),
        _descriptionController.text.trim(),
        _startDate!,
        _endDate!,
      );

      for (final task in _tasks) {
        await ApiService().addTaskToChallenge(
          challengeId: challengeId,
          task: task,
        );
      }

      setState(() {
        _success = 'Desafio criado com sucesso!';
        _error = null;
        _titleController.clear();
        _descriptionController.clear();
        _startDate = null;
        _endDate = null;
        _tasks.clear();
      });

      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pop(true);
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceAll('Exception', '').trim();
        _success = null;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickStartDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now().add(Duration(days: 365 * 2)),
    );

    if (picked != null) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  Future<void> _pickEndDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365 * 2)),
    );

    if (picked != null) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Novo Desafio')),
      body: SingleChildScrollView(
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
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: Text('Início: ${_formatDate(_startDate)}'),
                    onTap: _pickStartDate,
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text('Fim: ${_formatDate(_endDate)}'),
                    onTap: _pickEndDate,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tarefas adicionadas',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: _openAddTaskDialog,
                  child: Text('Adicionar Tarefa'),
                ),
              ],
            ),
            ..._tasks.asMap().entries.map(
              (e) => ListTile(
                title: Text(e.value.title),
                subtitle: Text('Recorrência: ${e.value.recurrenceType}'),
                trailing: IconButton(
                  onPressed: () => _removeTask(e.key),
                  icon: Icon(Icons.delete, color: Colors.red),
                ),
              ),
            ),
            SizedBox(height: 15),
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
                      onPressed: _saveChallenge,
                      child: Text('Salvar Desafio'),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

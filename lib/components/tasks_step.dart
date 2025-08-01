import 'package:challenge_app_flutter/models/challenge_draft.dart';
import 'package:challenge_app_flutter/models/task_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TasksStep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final draft = Provider.of<ChallengeDraft>(context);
    return Column(
      children: [
        if (draft.tasks.isEmpty)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Nenhuma task adicionada ainda.'),
          ),
        ...draft.tasks.asMap().entries.map(
          (entry) => Card(
            child: ListTile(
              title: Text(entry.value.title),
              subtitle: Text('Recorrência: ${entry.value.recurrenceType}'),
              trailing: IconButton(
                onPressed: () => draft.removeTaskAt(entry.key),
                icon: Icon(Icons.delete, color: Colors.red),
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () async {
            final newTask = await showDialog<TaskInput>(
              context: context,
              builder: (_) => TaskFormDialog(),
            );
            if (newTask != null) {
              draft.addTask(newTask);
            }
          },
          icon: Icon(Icons.add),
          label: Text('Adicionar Tarefa'),
        ),
      ],
    );
  }
}

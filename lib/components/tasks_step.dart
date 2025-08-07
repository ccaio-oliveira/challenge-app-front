import 'package:challenge_app_flutter/models/challenge_draft.dart';
import 'package:challenge_app_flutter/models/task_input.dart';
import 'package:challenge_app_flutter/components/task_form_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TasksStep extends StatelessWidget {
  Future<TaskInput?> showTaskFormBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        maxChildSize: 0.95,
        minChildSize: 0.4,
        expand: false,
        builder: (context, scrollController) {
          return TaskFormBottomSheet(scrollController: scrollController);
        },
      ),
    );
  }

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
            final newTask = await showTaskFormBottomSheet(context);
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

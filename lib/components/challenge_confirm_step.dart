import 'package:challenge_app_flutter/models/challenge_draft.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChallengeConfirmStep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final draft = Provider.of<ChallengeDraft>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Título: ${draft.title ?? ""}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text('Descrição: ${draft.description ?? ""}'),
        Text('Data de Início: ${draft.startDate ?? ""}'),
        Text('Data de Término: ${draft.endDate ?? ""}'),
        Divider(),
        Text('Tasks: ${draft.tasks.length}'),
        ...draft.tasks.map((t) => Text('- ${t.title} (${t.recurrenceType})')),
      ],
    );
  }
}

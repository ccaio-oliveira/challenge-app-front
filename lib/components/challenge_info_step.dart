import 'package:challenge_app_flutter/models/challenge_draft.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ChallengeInfoStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  ChallengeInfoStep({required this.formKey});

  @override
  Widget build(BuildContext context) {
    final draft = Provider.of<ChallengeDraft>(context);
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            initialValue: draft.title,
            decoration: InputDecoration(labelText: 'Título do desafio'),
            onChanged: draft.setTitle,
            validator: (val) =>
                (val == null || val.isEmpty) ? 'Título obrigatório' : null,
          ),
          SizedBox(height: 10),
          TextFormField(
            initialValue: draft.description,
            decoration: InputDecoration(labelText: 'Descrição do desafio'),
            onChanged: draft.setDescription,
            minLines: 2,
            maxLines: 4,
            validator: (val) =>
                (val == null || val.isEmpty) ? 'Descrição obrigatória' : null,
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ListTile(
                  title: Text(
                    'Início: ${draft.startDate != null ? _formatDate(draft.startDate!) : 'Selecione'}',
                  ),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: draft.startDate ?? DateTime.now(),
                      firstDate: DateTime.now().subtract(Duration(days: 365)),
                      lastDate: DateTime.now().add(Duration(days: 365 * 2)),
                    );
                    if (picked != null) draft.setStartDate(picked);
                  },
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text(
                    'Fim: ${draft.endDate != null ? _formatDate(draft.endDate!) : 'Selecione'}',
                  ),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: draft.endDate ?? DateTime.now(),
                      firstDate: DateTime.now().subtract(Duration(days: 365)),
                      lastDate: DateTime.now().add(Duration(days: 365 * 2)),
                    );
                    if (picked != null) draft.setEndDate(picked);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}

import 'package:challenge_app_flutter/models/task_input.dart';
import 'package:challenge_app_flutter/theme/app_colors.dart';
import 'package:flutter/material.dart';

class TaskFormBottomSheet extends StatefulWidget {
  final ScrollController scrollController;
  const TaskFormBottomSheet({required this.scrollController});

  @override
  State<TaskFormBottomSheet> createState() => TaskFormBottomSheetState();
}

class TaskFormBottomSheetState extends State<TaskFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  String _recurrenceType = 'daily';
  String? _recurrenceData;
  bool _requiredPhoto = false;
  int? _points;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(0, -2),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Form(
        key: _formKey,
        child: ListView(
          controller: widget.scrollController,
          shrinkWrap: true,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: theme.dividerColor,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            Text(
              'Nova Tarefa',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),

            TextFormField(
              decoration: InputDecoration(
                labelText: 'Título *',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor:
                    theme.inputDecorationTheme.fillColor ?? Colors.grey[100],
              ),
              style: theme.textTheme.bodyLarge,
              validator: (val) =>
                  (val == null || val.isEmpty) ? 'Título obrigatório' : null,
              onChanged: (val) => _title = val,
            ),
            SizedBox(height: 12),

            TextFormField(
              decoration: InputDecoration(
                labelText: 'Descrição',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor:
                    theme.inputDecorationTheme.fillColor ?? Colors.grey[100],
              ),
              minLines: 2,
              maxLines: 4,
              onChanged: (val) => _description = val,
            ),
            SizedBox(height: 12),

            DropdownButtonFormField<String>(
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
                  child: Text('Fins de Semana'),
                ),
              ],
              onChanged: (val) {
                setState(() {
                  _recurrenceType = val!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Recorrência *',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor:
                    theme.inputDecorationTheme.fillColor ?? Colors.grey[100],
              ),
              style: theme.textTheme.bodyLarge,
            ),
            SizedBox(height: 12),

            TextFormField(
              decoration: InputDecoration(
                labelText: 'Dados de recorrência (dias/datas)',
                hintText: 'Ex: 1,3,5 ou 2025-08-01',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor:
                    theme.inputDecorationTheme.fillColor ?? Colors.grey[100],
              ),
              onChanged: (val) => _recurrenceData = val,
            ),
            SizedBox(height: 12),

            TextFormField(
              decoration: InputDecoration(
                labelText: 'Pontos',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor:
                    theme.inputDecorationTheme.fillColor ?? Colors.grey[100],
              ),
              keyboardType: TextInputType.number,
              onChanged: (val) => _points = int.tryParse(val),
            ),
            SizedBox(height: 12),

            SwitchListTile(
              title: Text('Exigir foto?', style: theme.textTheme.bodyLarge),
              value: _requiredPhoto,
              onChanged: (val) {
                setState(() {
                  _requiredPhoto = val;
                });
              },
              contentPadding: EdgeInsets.zero,
              activeColor: theme.colorScheme.primary,
            ),
            SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancelar', style: TextStyle(fontSize: 16)),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.pop(
                          context,
                          TaskInput(
                            title: _title,
                            description: _description,
                            recurrenceType: _recurrenceType,
                            recurrenceData: _recurrenceData,
                            points: _points,
                            requiredPhoto: _requiredPhoto,
                          ),
                        );
                      }
                    },
                    child: Text('Salvar', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

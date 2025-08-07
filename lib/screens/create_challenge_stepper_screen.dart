import 'package:challenge_app_flutter/components/challenge_confirm_step.dart';
import 'package:challenge_app_flutter/components/challenge_info_step.dart';
import 'package:challenge_app_flutter/components/tasks_step.dart';
import 'package:challenge_app_flutter/models/challenge_draft.dart';
import 'package:challenge_app_flutter/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateChallengeStepperScreen extends StatefulWidget {
  const CreateChallengeStepperScreen({Key? key}) : super(key: key);

  @override
  State<CreateChallengeStepperScreen> createState() =>
      _CreateChallengeStepperScreenState();
}

class _CreateChallengeStepperScreenState
    extends State<CreateChallengeStepperScreen> {
  int _currentStep = 0;
  final _challengeFormKey = GlobalKey<FormState>();
  bool _isSaving = false;
  String? _error;

  Future<void> _saveChallenge(
    BuildContext context,
    ChallengeDraft draft,
  ) async {
    setState(() {
      _isSaving = true;
      _error = null;
    });
    try {
      final id = await ApiService().createChallenge(
        draft.title!,
        draft.description!,
        draft.startDate!,
        draft.endDate!,
      );
      for (final task in draft.tasks) {
        await ApiService().addTaskToChallenge(challengeId: id, task: task);
      }
      draft.clear();
      Navigator.of(context).pop(true);
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChallengeDraft(),
      child: Consumer<ChallengeDraft>(
        builder: (context, draft, _) => Scaffold(
          appBar: AppBar(title: Text('Novo Desafio')),
          body: Stepper(
            type: StepperType.horizontal,
            currentStep: _currentStep,
            onStepContinue: () async {
              switch (_currentStep) {
                case 0:
                  if (_challengeFormKey.currentState!.validate()) {
                    setState(() => _currentStep = 1);
                  }
                  break;
                case 1:
                  if (draft.tasks.isNotEmpty) {
                    setState(() => _currentStep = 2);
                  } else {
                    setState(() => _error = 'Adicione pelo menos uma tarefa.');
                  }
                  break;
                case 2:
                  await _saveChallenge(context, draft);
                  break;
              }
            },
            onStepCancel: () {
              if (_currentStep > 0) setState(() => _currentStep--);
            },
            controlsBuilder: (context, details) => Row(
              children: [
                if (_currentStep < 2)
                  ElevatedButton(
                    onPressed: details.onStepContinue,
                    child: Text('Próximo'),
                  ),
                if (_currentStep == 2)
                  ElevatedButton(
                    onPressed: details.onStepContinue,
                    child: _isSaving
                        ? CircularProgressIndicator()
                        : Text('Salvar'),
                  ),
                if (_currentStep > 0)
                  TextButton(
                    onPressed: details.onStepCancel,
                    child: Text('Voltar'),
                  ),
              ],
            ),
            steps: [
              Step(
                title: Text('Desafio'),
                content: ChallengeInfoStep(formKey: _challengeFormKey),
                isActive: _currentStep == 0,
              ),
              Step(
                title: Text('Tarefas'),
                content: TasksStep(),
                isActive: _currentStep == 1,
              ),
              Step(
                title: Text('Confirmação'),
                content: ChallengeConfirmStep(),
                isActive: _currentStep == 2,
              ),
            ],
          ),
          bottomNavigationBar: _error != null
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(_error!, style: TextStyle(color: Colors.red)),
                )
              : null,
        ),
      ),
    );
  }
}

import 'package:challenge_app_flutter/models/task_input.dart';
import 'package:flutter/widgets.dart';

class ChallengeDraft extends ChangeNotifier {
  String? title;
  String? description;
  DateTime? startDate;
  DateTime? endDate;
  final List<TaskInput> tasks = [];

  void setTitle(String value) {
    title = value;
    notifyListeners();
  }

  void setDescription(String value) {
    description = value;
    notifyListeners();
  }

  void setStartDate(DateTime value) {
    startDate = value;
    notifyListeners();
  }

  void setEndDate(DateTime value) {
    endDate = value;
    notifyListeners();
  }

  void addTask(TaskInput task) {
    tasks.add(task);
    notifyListeners();
  }

  void removeTaskAt(int index) {
    tasks.removeAt(index);
    notifyListeners();
  }

  void clear() {
    title = null;
    description = null;
    startDate = null;
    endDate = null;
    tasks.clear();
    notifyListeners();
  }
}

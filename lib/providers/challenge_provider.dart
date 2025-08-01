import 'package:challenge_app_flutter/models/challenge_draft.dart';
import 'package:flutter/widgets.dart';

class ChallengeProvider with ChangeNotifier {
  final ChallengeDraft draft = ChallengeDraft();

  void clear() {
    draft.clear();
    notifyListeners();
  }
}

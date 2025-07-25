import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Widget createTestApp(Widget child) {
  return MaterialApp(home: child);
}

Finder findTextFieldByLabel(String label) {
  return find.widgetWithText(TextField, label);
}

void expectLoading() {
  expect(find.byType(CircularProgressIndicator), findsOneWidget);
}

void expectNoLoading() {
  expect(find.byType(CircularProgressIndicator), findsNothing);
}

Future<void> tapAndSettle(WidgetTester tester, Finder finder) async {
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> enterTextAndPump(
  WidgetTester tester,
  Finder finder,
  String text,
) async {
  await tester.enterText(finder, text);
  await tester.pump();
}

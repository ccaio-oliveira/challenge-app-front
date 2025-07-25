import 'package:challenge_app_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('App Integration Tests', () {
    testWidgets('complete login flow', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());

      expect(find.text('Entrar'), findsNWidgets(2));

      await tester.tap(find.text('Não tem uma conta? Cadastre-se'));
      await tester.pumpAndSettle();

      expect(find.text('Cadastrar'), findsNWidgets(2));

      await tester.tap(find.text('Já tem uma conta? Faça login'));
      await tester.pumpAndSettle();

      expect(find.text('Entrar'), findsNWidgets(2));
    });

    testWidgets('app has correct title', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());

      final MaterialApp app = tester.widget(find.byType(MaterialApp));

      expect(app.title, 'Challenge App');
      expect(app.debugShowCheckedModeBanner, false);
      expect(app.theme, isNotNull);
    });
  });
}

import 'package:challenge_app_flutter/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SignupScreen', () {
    testWidgets('renders all required elements', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: SignupScreen()));

      expect(find.text('Cadastrar'), findsNWidgets(2)); // AppBar e botão
      expect(find.text('Nome'), findsOneWidget);
      expect(find.text('E-mail'), findsOneWidget);
      expect(find.text('Senha'), findsOneWidget);
      expect(find.text('Já tem uma conta? Faça login'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(3));
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);
    });

    testWidgets('shows error message when fields are empty', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: SignupScreen()));

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.text('Todos os campos são obrigatórios'), findsOneWidget);
    });

    testWidgets('shows error message for invalid email', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: SignupScreen()));

      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(0), 'João Silva');
      await tester.enterText(textFields.at(1), 'email_invalido');
      await tester.enterText(textFields.at(2), 'password123');

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.text('Informe um e-mail válido'), findsOneWidget);
    });

    testWidgets('shows error message for short password', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: SignupScreen()));

      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(0), 'João Silva');
      await tester.enterText(textFields.at(1), 'joao@test.com');
      await tester.enterText(textFields.at(2), '123');

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      final errorFinder = find.byWidgetPredicate(
        (widget) =>
            widget is Text &&
            widget.data != null &&
            widget.data!.toLowerCase().contains('senha'),
      );

      if (errorFinder.evaluate().isEmpty) {
        expect(find.byType(SnackBar), findsOneWidget);
      } else {
        expect(
          find.text('A senha deve ter pelo menos 6 caracteres'),
          findsOneWidget,
        );
      }
    });

    testWidgets('navigates back when login button is tapped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SignupScreen()),
                ),
                child: Text('Go to Signup'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Go to Signup'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Já tem uma conta? Faça login'));
      await tester.pumpAndSettle();

      expect(find.text('Go to Signup'), findsOneWidget);
    });

    testWidgets('text fields have correct properties', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: SignupScreen()));

      final textFields = find.byType(TextField);

      expect(textFields, findsNWidgets(3));

      final emailField = tester.widget<TextField>(textFields.at(1));
      expect(emailField.keyboardType, TextInputType.emailAddress);

      final passwordField = tester.widget<TextField>(textFields.at(2));
      expect(passwordField.obscureText, true);
    });
  });
}

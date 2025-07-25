import 'package:challenge_app_flutter/screens/login_screen.dart';
import 'package:challenge_app_flutter/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoginScreen', () {
    testWidgets('renders all required elements', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginScreen()));

      // Verifica se todos os elementos estão presentes
      expect(find.text('Entrar'), findsNWidgets(2)); // AppBar e botão
      expect(find.text('E-mail'), findsOneWidget);
      expect(find.text('Senha'), findsOneWidget);
      expect(find.text('Não tem uma conta? Cadastre-se'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);
    });

    testWidgets('shows error message when fields are empty', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: LoginScreen()));

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.text('Por favor, preencha todos os campos.'), findsOneWidget);
    });

    testWidgets('shows error message for invalid email', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: LoginScreen()));

      await tester.enterText(find.byType(TextField).first, 'email_invalido');
      await tester.enterText(find.byType(TextField).last, 'password123');

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.text('Por favor, insira um e-mail válido.'), findsOneWidget);
    });

    testWidgets('shows error message for short password', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: LoginScreen()));

      // Preenche com senha muito curta
      await tester.enterText(find.byType(TextField).first, 'test@test.com');
      await tester.enterText(find.byType(TextField).last, '123');

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(
        find.text('A senha deve ter pelo menos 6 caracteres.'),
        findsOneWidget,
      );
    });

    testWidgets('navigates to signup screen when signup button is tapped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: LoginScreen()));

      // Toca no botão de cadastro
      await tester.tap(find.text('Não tem uma conta? Cadastre-se'));
      await tester.pumpAndSettle();

      // Verifica se navegou para a tela de cadastro
      expect(find.byType(SignupScreen), findsOneWidget);
    });

    testWidgets('email field has correct keyboard type', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: LoginScreen()));

      final emailField = tester.widget<TextField>(find.byType(TextField).first);

      expect(emailField.keyboardType, TextInputType.emailAddress);
    });

    testWidgets('password field is obscured', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginScreen()));

      final passwordField = tester.widget<TextField>(
        find.byType(TextField).last,
      );

      expect(passwordField.obscureText, true);
    });
  });
}

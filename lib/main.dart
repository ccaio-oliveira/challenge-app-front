import 'package:challenge_app_flutter/screens/login_screen.dart';
import 'package:challenge_app_flutter/theme/theme_data.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Challenge App',
      theme: appDarkBlueTheme,
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

import 'package:flutter/material.dart';
import 'Authentication/auth_screen.dart';
import 'Authentication/registration_screen.dart';
import 'core/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OneStopRx Driver',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const RegistrationScreen(), // Changed to test the registration screen
    );
  }
}

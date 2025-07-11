import 'package:flutter/material.dart';
import 'constants/app_constants.dart';
import 'pages/main_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const PencilApp());
}

/// Pencil应用程序主类
class PencilApp extends StatelessWidget {
  const PencilApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

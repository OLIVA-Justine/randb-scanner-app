import 'package:flutter/material.dart';
import 'theme.dart';
import '../core/widgets/main_shell.dart';

class PersonalScannerApp extends StatelessWidget {
  const PersonalScannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Scanner',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainShell(),
    );
  }
}
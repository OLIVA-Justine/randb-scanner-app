import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app/app.dart';
 
void main() {
  WidgetsFlutterBinding.ensureInitialized();
 
  // Lock orientation to portrait
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
 
  // Make status bar transparent
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
 
  runApp(const PersonalScannerApp());
}
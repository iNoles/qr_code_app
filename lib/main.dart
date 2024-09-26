import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'scanner_screen.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensures that the Flutter framework is initialized
  await Hive.initFlutter(); // Initializes Hive for Flutter
  await Hive.openBox<String>(
      'scannedCodes'); // Opens a box to store scanned QR codes as strings
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Code Scanner',
      theme: ThemeData(
        useMaterial3: true, // Enable Material 3
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue, // Primary color
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true, // Enable Material 3 in dark mode
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
      themeMode:
          ThemeMode.system, // Automatically switch based on system settings
      home: const ScannerScreen(),
    );
  }
}

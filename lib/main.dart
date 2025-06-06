import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:nowtask/helpers/logs.dart';
import 'package:nowtask/screens/home_screen.dart';

void main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      runApp(DevicePreview(enabled: kIsWeb, builder: (context) => const MyApp()));
    },
    (error, stackTrace) {
      errorLog("Error generating app: ${error.toString()}"); // Atrapar logs de errores
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NowTask',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.tealAccent), useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}

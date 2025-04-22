import 'package:flutter/material.dart';
import 'package:stockmate_app/screens/register_screen.dart';
import 'screens/login_screen.dart';
import 'services/objectbox_service.dart';

late ObjectBoxService objectBox;

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //initialize ObjectBox & gives us access to userBox & itemBox
  print("⏳ Initializing ObjectBox...");

  objectBox = await ObjectBoxService.create();
  
  print("✅ ObjectBox Initialized");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stokemate',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const LoginScreen(),
    );
  }
}
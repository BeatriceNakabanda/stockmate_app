import 'package:flutter/material.dart';
import 'screens/register_screen.dart';
import 'services/objectbox_service.dart';

late ObjectBoxService objectBox;

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //initialize ObjectBox & gives us access to userBox & itemBox
  objectBox = await ObjectBoxService.create();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stokemate',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: RegisterScreen(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'services/objectbox_service.dart';
import 'models/user_model.dart';

late ObjectBoxService objectBox;

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //initialize ObjectBox & gives us access to userBox & itemBox
  print("Initializing ObjectBox...");

  objectBox = await ObjectBoxService.create();
  
  print("ObjectBox Initialized");
  final prefs = await SharedPreferences.getInstance();
  final savedUserId = prefs.getInt('loggedInUserId');

  UserModel? user;
  if (savedUserId != null) {
    user = objectBox.userBox.get(savedUserId);
  }

  runApp(MyApp(user: user));
}

class MyApp extends StatelessWidget {
  final UserModel? user; 
  const MyApp({super.key, required this.user});

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
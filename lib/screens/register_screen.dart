import 'package:flutter/material.dart';
import 'package:stockmate_app/main.dart';

import '../models/user_model.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final ValueNotifier<String> accountType = ValueNotifier('free');

  RegisterScreen({super.key});

    void registerUser(BuildContext context) {
    final user = UserModel(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      email: emailController.text,
      userName: userNameController.text,
      accountType: accountType.value,
    );

    objectBox.userBox.put(user);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("User saved locally!")),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: firstNameController, decoration: const InputDecoration(labelText: "First Name")),
            TextField(controller: lastNameController, decoration: const InputDecoration(labelText: "Last Name")),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: userNameController, decoration: const InputDecoration(labelText: "Prefered Username")),
            ValueListenableBuilder<String>(
              valueListenable: accountType,
              builder: (context, value, _) {
                return DropdownButton<String>(
                  value: value,
                  items: const [
                    DropdownMenuItem(value: 'free', child: Text("Free")),
                    DropdownMenuItem(value: 'standard', child: Text("Standard")),
                  ],
                  onChanged: (val) => accountType.value = val!,
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => registerUser(context),
              child: const Text("Register"),
            )
          ],
        ),
      ),
    );
  }
}
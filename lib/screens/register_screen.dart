import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../main.dart'; // to access global objectBox

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  String? _selectedAccountType;

  void _registerUser(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final user = UserModel(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        accountType: _selectedAccountType!,
        userName: _userNameController.text.trim()
      );

      objectBox.userBox.put(user);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ User saved locally!")),
      );

      // Optionally clear form
      _formKey.currentState!.reset();
      setState(() {
        _selectedAccountType = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: "First Name"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter first name" : null,
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: "Last Name"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter last name" : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter email" : null,
              ),
              TextFormField(
                controller: _userNameController,
                decoration: const InputDecoration(labelText: "Prefered Username"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter Username" : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedAccountType,
                decoration: const InputDecoration(
                  labelText: "Account Type",
                ),
                items: const [
                  DropdownMenuItem(
                    value: null,
                    child: Text(
                      "Select Account Type",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  DropdownMenuItem(value: 'free', child: Text("Free")),
                  DropdownMenuItem(value: 'standard', child: Text("Standard")),
                ],
                validator: (value) =>
                    value == null ? "Please select an account type" : null,
                onChanged: (value) {
                  setState(() {
                    _selectedAccountType = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _registerUser(context),
                child: const Text("Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

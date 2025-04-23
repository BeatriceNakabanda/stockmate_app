import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../main.dart';
import '../models/stock_item.dart';
import '../models/user_model.dart';

class AddItemScreen extends StatefulWidget {
  final UserModel user;
  const AddItemScreen({super.key, required this.user});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _pickedImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source, imageQuality: 75);
    if (pickedFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      final filename = p.basename(pickedFile.path);
      final savedImage = await File(pickedFile.path).copy('${directory.path}/$filename');

      setState(() {
        _pickedImage = savedImage;
      });
    }
  }

  void _saveItem() {
    if (_formKey.currentState!.validate() && _pickedImage != null) {
      final item = StockItem(
        name: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        imagePath: _pickedImage!.path,
        createdAt: DateTime.now(),
      );

      objectBox.itemBox.put(item);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Item added successfully!")),
      );

      Navigator.pop(context); // go back to HomeScreen
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Please fill all fields and pick an image.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Stock Item")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Item Name"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter item name" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter description" : null,
                maxLines: 1,
              ),
              const SizedBox(height: 16),
              _pickedImage != null
                  ? Image.file(_pickedImage!, height: 150)
                  : const Text("No image selected."),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: () => _pickImage(ImageSource.camera),
                    tooltip: "Take Photo",
                  ),
                  IconButton(
                    icon: const Icon(Icons.photo),
                    onPressed: () => _pickImage(ImageSource.gallery),
                    tooltip: "Pick from Gallery",
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveItem,
                child: const Text("Save Item"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

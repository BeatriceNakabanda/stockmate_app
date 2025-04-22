import 'dart:io';

import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/inventory_item.dart';
import '../main.dart';

class HomeScreen extends StatefulWidget {
  final UserModel user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<InventoryItem> userItems = [];

  @override
  void initState() {
    super.initState();
    _loadInventory();
  }

  void _loadInventory() {
    // For now, load ALL items
    // Later, you can filter by userId if you add it
    userItems = objectBox.itemBox.getAll();

    setState(() {}); // refresh UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome, ${widget.user.firstName}"),
      ),
      body: userItems.isEmpty
          ? const Center(child: Text("No items found."))
          : ListView.builder(
              itemCount: userItems.length,
              itemBuilder: (context, index) {
                final item = userItems[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: ListTile(
                    leading: item.imagePath.isNotEmpty
                        ? Image.file(
                            File(item.imagePath),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.image_not_supported),
                    title: Text(item.name),
                    subtitle: Text(item.description),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Go to AddItem screen next (we’ll build this soon)
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:stockmate_app/models/stock_item.dart';

class ItemDetailsScreen extends StatelessWidget {
  final StockItem item;

  const ItemDetailsScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            item.imagePath.isNotEmpty
                ? Image.file(
                    File(item.imagePath),
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : const Icon(Icons.image_not_supported, size: 100),
            const SizedBox(height: 20),
            Text("Name", style: Theme.of(context).textTheme.labelLarge),
            Text(item.name, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            Text("Description", style: Theme.of(context).textTheme.labelLarge),
            Text(item.description),
            const SizedBox(height: 10),
            Text("Added On", style: Theme.of(context).textTheme.labelLarge),
            Text(
              "${item.createdAt.toLocal()}".split(".").first,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

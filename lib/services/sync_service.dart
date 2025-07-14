import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:stockmate_app/main.dart';
import '../models/stock_item.dart';
import '../objectbox_model.dart';
import 'package:stockmate_app/objectbox.g.dart';

class SyncService {
  final _dbRef = FirebaseDatabase.instance.ref("inventory");

  Future<bool> isOnline() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  Future<void> syncUnsyncedItems() async {
    print("🔄 Starting sync...");
    final unsynced = objectBox.itemBox
        .query(StockItem_.synced.equals(false))
        .build()
        .find();
    print("📦 Found ${unsynced.length} unsynced items");

    for (final item in unsynced) {
      try{
        print("➡️ Syncing item: ${item.name}");
        final newRef = _dbRef.push(); // generates unique ID
        await newRef.set(item.toMap());
      //   await newRef.set({
      //   "name": item.name,
      //   "description": item.description,
      //   "imagePath": item.imagePath,
      //   "createdAt": item.createdAt.toIso8601String(),
      // });


      item.synced = true;
      objectBox.itemBox.put(item); // mark as synced
      } catch(e) {
          print("❌ Error syncing item: $e");
      }
    }
  }
}

//make syncing to/from Firebase easier
extension StockItemMapper on StockItem {
  Map<String, dynamic> toMap() => {
    'name': name,
    'description': description,
    'imagePath': imagePath,
    'createdAt': createdAt.toIso8601String(),
  };

  static StockItem fromMap(Map<String, dynamic> map) => StockItem(
    name: map['name'],
    description: map['description'],
    imagePath: map['imagePath'],
    createdAt: DateTime.parse(map['createdAt']),
    synced: true,
  );
}


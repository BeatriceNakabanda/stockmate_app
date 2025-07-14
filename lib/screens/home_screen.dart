import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockmate_app/screens/item_details_screen.dart';
import '../models/user_model.dart';
import '../models/stock_item.dart';
import '../main.dart';
import 'add_item_screen.dart';
import 'login_screen.dart';
import '../services/sync_service.dart';

class HomeScreen extends StatefulWidget {
  final UserModel user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<StockItem> userItems = [];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final SyncService _syncService;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _syncService = SyncService();

    _loadInventory();
    _trySyncOnStartup();
    _listenForConnectivityChanges();
  }

  void _trySyncOnStartup() async {
    if (await _syncService.isOnline()) {
      await _syncService.syncUnsyncedItems();
      _loadInventory(); // Refresh list after syncing
    }
  }

  void _listenForConnectivityChanges() {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      if (result != ConnectivityResult.none) {
        await _syncService.syncUnsyncedItems();
        _loadInventory(); // Refresh list after sync
      }
    });
  }


  void _loadInventory() {
    // For now, load ALL items
    // Todo ilter by userId if you add it
    userItems = objectBox.itemBox.getAll();

    setState(() {}); // refresh UI
  }

  @override
void dispose() {
  //Dispose of the subscription
  _connectivitySubscription.cancel();
  super.dispose();
}


  void _onTabTapped(int index) {
    if(index == 1){
    // Navigate to Add Item screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddItemScreen(user: widget.user),
      ),
    ).then((_) {
      // After adding an item and returning
      _loadInventory();       // Reload inventory list
      _selectedIndex = 0;     // Go back to Home tab
      setState(() {});
    });
    } else {
      // Normal tab switching for Home and Profile
      setState(() {
      _selectedIndex = index;
    });
    }
  }

  Widget _buildInventoryList() {
    if (userItems.isEmpty) {
      return const Center(child: Text("No items in stock."));
    }

    return ListView.builder(
      itemCount: userItems.length,
      itemBuilder: (context, index) {
        final item = userItems[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            leading: item.imagePath.isNotEmpty
                ? Image.file(
                    File(item.imagePath),
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  )
                : const Icon(Icons.inventory),
            title: Text(item.name),
            subtitle: Text(item.description),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ItemDetailsScreen(item: item),
                ),
              );
            },
          ),
        );
      },
    );
  }
  Widget _buildProfilePlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person, size: 64),
          const SizedBox(height: 10),
          Text(
            "${widget.user.firstName} ${widget.user.lastName}",
            style: const TextStyle(fontSize: 20),
          ),
          Text("Username: ${widget.user.userName}"),
          Text("Account: ${widget.user.accountType}"),
          Text("Email: ${widget.user.email}"),
        ],
      ),
    );
  }

    Widget _buildCurrentTab() {
    switch (_selectedIndex) {
      case 0:
        return _buildInventoryList();
      case 2:
        return _buildProfilePlaceholder();
      default:
        return const Center(child: Text("Unknown tab"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stock Mate"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.store, size: 40, color: Colors.white),
                  const SizedBox(height: 8),
                  Text(
                    widget.user.firstName,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  Text(
                    widget.user.accountType.toUpperCase(),
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text("Dashboard"),
              onTap: () {
                _onTabTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.list_alt),
              title: const Text("Inventory List"),
              onTap: () {
                _onTabTapped(0);
                Navigator.pop(context);
              },
            ),
            // ListTile(
            //   leading: const Icon(Icons.bar_chart),
            //   title: const Text("Reports"),
            //   onTap: () {
            //     // TODO: Implement reports page
            //     Navigator.pop(context);
            //   },
            // ),
            ListTile(
              leading: const Icon(Icons.star),
              title: Text("Account Type: ${widget.user.accountType}"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('loggedInUserId'); // clear session
                Navigator.pop(context); // close drawer
                // Navigate to LoginScreen and remove all previous routes
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false, // Remove all previous routes
                );
              },
            ),
          ],
        ),
      ),
      body: _buildCurrentTab(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: "Add"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // Go to AddItem screen next (we’ll build this soon)
      //   },
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}

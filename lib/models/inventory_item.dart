import 'package:objectbox/objectbox.dart';

@Entity()
class InventoryItem {
  int id;
  String name;
  String description;
  String imagePath;
  DateTime createdAt;

  InventoryItem({
    this.id = 0,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.createdAt,
  });
}

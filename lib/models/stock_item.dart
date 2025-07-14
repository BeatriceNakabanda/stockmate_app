import 'package:objectbox/objectbox.dart';

@Entity()
class StockItem {
  @Id()
  int id;
  String name;
  String description;
  String imagePath;
  DateTime createdAt;
  bool synced;

  StockItem({
    this.id = 0,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.createdAt,
    this.synced = false,
  });
}

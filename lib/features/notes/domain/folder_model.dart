import 'package:hive/hive.dart';

part 'folder_model.g.dart';

@HiveType(typeId: 1)
class FolderModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  bool pinned;

  @HiveField(3)
  DateTime createdAt;

  FolderModel({
    required this.id,
    required this.name,
    this.pinned = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

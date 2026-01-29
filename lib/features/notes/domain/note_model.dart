
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'note_model.g.dart';

@HiveType(typeId: 2)
class NoteModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String folderId;

  @HiveField(2)
  String title;

  @HiveField(3)
  String content;

  @HiveField(4)
  bool pinned;

  @HiveField(5)
  bool isDeleted;

  @HiveField(6)
  DateTime createdAt;

  @HiveField(7)
  DateTime? deletedAt;

  @HiveField(8)
  int? colorValue;

  NoteModel({
    required this.id,
    required this.folderId,
    required this.title,
    required this.content,
    this.pinned = false,
    this.isDeleted = false,
    DateTime? createdAt,
    this.deletedAt,
    this.colorValue,
  }) : createdAt = createdAt ?? DateTime.now();
  Color get color =>
      colorValue != null ? Color(colorValue!) : Colors.transparent;
  set color(Color c) => colorValue = c.value;
}

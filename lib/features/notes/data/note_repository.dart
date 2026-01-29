import 'dart:ui';

import 'package:hive/hive.dart';
import 'package:recallhub_frontend/features/notes/domain/note_model.dart';

class NoteRepository {
  final Box<NoteModel> box = Hive.box<NoteModel>('notes');

  List<NoteModel> getNotesForFolder(String folderId) {
    return box.values
        .where((n) => n.folderId == folderId && !n.isDeleted)
        .toList();
  }

  List<NoteModel> getTrashNotesForFolder(String folderId) {
    return box.values
        .where((n) => n.folderId == folderId && n.isDeleted)
        .toList();
  }

  Future<void> createNote({
    required String folderId,
    required String title,
    required String content,
    Color? color,
  }) async {
    final note = NoteModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      folderId: folderId,
      title: title,
      content: content,
      // ignore: deprecated_member_use
      colorValue: color?.value,
    );
    await box.put(note.id, note);
  }

  Future<void> updateNote(NoteModel note) async {
    await note.save();
  }

  Future<void> softDeleteNote(NoteModel note) async {
    note.isDeleted = true;
    note.deletedAt = DateTime.now();
    await note.save();
  }

  Future<void> restoreNote(NoteModel note) async {
    note.isDeleted = false;
    note.deletedAt = null;
    await note.save();
  }

  Future<void> deleteForever(NoteModel note) async {
    await note.delete();
  }

  Future<void> cleanOldTrash() async {
    final now = DateTime.now();
    for (final note in box.values) {
      if (note.isDeleted &&
          note.deletedAt != null &&
          now.difference(note.deletedAt!).inHours >= 48) {
        await note.delete();
      }
    }
  }
}

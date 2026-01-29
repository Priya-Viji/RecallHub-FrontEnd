import 'package:hive/hive.dart';
import 'package:recallhub_frontend/features/notes/domain/folder_model.dart';

class FolderRepository {
  final Box<FolderModel> box = Hive.box<FolderModel>('folders');

  Future<void> createFolder(String name) async {
    final folder = FolderModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
    );
    await box.put(folder.id, folder);
  }

  List<FolderModel> getFolders() {
    return box.values.toList();
  }

  Future<void> updateFolder(FolderModel folder) async {
    await folder.save();
  }

  Future<void> deleteFolder(FolderModel folder) async {
    await folder.delete();
  }
}

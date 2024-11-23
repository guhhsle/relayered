import 'package:flutter/material.dart';
import 'folder_options.dart';
import 'task.dart';
import '../template/functions.dart';
import '../classes/structure.dart';
import '../classes/database.dart';
import '../classes/folder.dart';
import '../template/layer.dart';
import '../template/tile.dart';
import '../classes/task.dart';

class FolderLayer extends Layer {
  String? folderID;
  Folder get folder => Structure().findFolder(folderID) ?? Folder.error();
  FolderLayer(this.folderID);
  @override
  void construct() {
    listenTo(Database());
    action = Tile(folder.name, Icons.folder_rounded, ' ', () {
      FolderOptions(folderID).show();
    });
    final pendingTasks = folder.items.where((task) => !task.done).map((task) {
      return task.toTile(TaskLayer(task.id).show);
    });
    final subfolders = Structure().folders.where((f) {
      return folder.nodes.contains(f.id);
    }).map((f) {
      return f.toTile(() {
        Navigator.of(context).pop();
        FolderLayer(f.id).show();
      });
    });
    final doneTasks = folder.items.where((task) => task.done).map((task) {
      return task.toTile(() {
        Navigator.of(context).pop();
        TaskLayer(task.id).show();
      });
    });
    list = [...pendingTasks, ...subfolders, ...doneTasks];
    trailing = [
      IconButton(
        icon: const Icon(Icons.add_rounded),
        onPressed: () async {
          if (Structure().findFolder(folderID) == null) {
            await Folder.defaultNew('').upload();
          }
          final input = await getInput('', 'New task');
          Task.defaultNew(folder, name: input).upload();
        },
      ),
    ];
  }
}

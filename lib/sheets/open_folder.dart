import 'package:flutter/material.dart';
import 'folder_options.dart';
import '../template/functions.dart';
import '../classes/database.dart';
import '../classes/folder.dart';
import '../functions/task.dart';
import '../template/layer.dart';
import '../template/tile.dart';
import '../classes/task.dart';
import '../data.dart';

class FolderLayer extends Layer {
  String? folderID;
  Folder get folder => Folder.fromID(folderID);
  FolderLayer(this.folderID);
  @override
  void construct() {
    listenTo(Database());
    action = Tile(folder.name, Icons.folder_rounded, ' ', () {
      FolderOptions(folderID).show();
    });
    list = tasksIn(folder, false) + foldersIn(folder) + tasksIn(folder, true);
    trailing = [
      IconButton(
        icon: const Icon(Icons.add_rounded),
        onPressed: () {
          if (!structure.containsKey(folderID)) {
            Folder.defaultNew('').upload();
          }
          getInput('', 'New task').then((name) {
            Task.defaultNew(folder, name: name).upload();
          });
        },
      ),
    ];
  }
}

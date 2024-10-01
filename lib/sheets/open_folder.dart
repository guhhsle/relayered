import 'package:flutter/material.dart';
import '../classes/folder.dart';
import '../data.dart';
import '../functions/task.dart';
import '../template/functions.dart';
import '../template/layer.dart';
import '../classes/task.dart';
import '../template/tile.dart';

Layer openFolder(Map map) {
  String id = map['id'];
  Folder folder = structure[id] ?? Folder.defaultNew('/ERROR');
  return Layer(
    trailing: (c) => [
      IconButton(
        icon: const Icon(Icons.add_rounded),
        onPressed: () {
          if (!structure.containsKey(id)) {
            Folder.defaultNew('').upload();
          }
          getInput('', 'New task').then((name) {
            Task.defaultNew(folder, name: name).upload();
          });
        },
      ),
    ],
    action: Tile(folder.name, Icons.folder_rounded, ' ', onTap: (c) {
      folder.options();
    }),
    list: tasksIn(id, false) + foldersIn(id) + tasksIn(id, true),
  );
}

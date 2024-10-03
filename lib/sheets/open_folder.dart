import 'package:flutter/material.dart';
import '../classes/folder.dart';
import '../data.dart';
import '../functions/task.dart';
import '../template/functions.dart';
import '../template/layer.dart';
import '../classes/task.dart';
import '../template/tile.dart';

Layer openFolder(Layer l) {
  String id = l.parameters['id'];
  Folder folder = structure[id] ?? Folder.defaultNew('/ERROR');
  l.action = Tile(folder.name, Icons.folder_rounded, ' ', () {
    folder.options();
  });
  l.list = tasksIn(id, false) + foldersIn(id) + tasksIn(id, true);
  l.trailing = [
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
  ];
  return l;
}

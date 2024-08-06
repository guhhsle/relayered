import 'package:flutter/material.dart';
import '../classes/folder.dart';
import '../data.dart';
import '../functions/task.dart';
import '../template/functions.dart';
import '../template/layer.dart';
import '../classes/task.dart';

Layer openFolder(dynamic id) {
  id as String;
  Folder folder = structure[id] ?? Folder.defaultNew('/ERROR');
  return Layer(
    trailing: (c) => [
      IconButton(
        icon: const Icon(Icons.add_rounded),
        onPressed: () async {
          if (!structure.containsKey(id)) {
            Folder folder = Folder.defaultNew('');
            await folder.upload();
          }
          Task.defaultNew(
            folder,
            name: await getInput('', hintText: 'New task'),
          ).upload();
        },
      ),
    ],
    action: Setting(
      folder.name,
      Icons.folder_rounded,
      ' ',
      (c) => folder.options(),
    ),
    list: tasksIn(id, false) + foldersIn(id) + tasksIn(id, true),
  );
}

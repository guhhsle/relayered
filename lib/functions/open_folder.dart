import 'package:flutter/material.dart';
import '../data.dart';
import '../task.dart';
import '../template/functions.dart';
import '../template/layer.dart';
import 'folder_options.dart';
import 'task.dart';

Future<Layer> openFolder(dynamic id) async {
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
      (c) => showSheet(
        func: folderOptions,
        param: id,
      ),
    ),
    list: tasksIn(id, false) + foldersIn(id) + tasksIn(id, true),
  );
}

import 'package:flutter/material.dart';
import '../data.dart';
import '../functions.dart';
import '../task.dart';
import 'folder_options.dart';
import 'layers.dart';

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
      '',
      Icons.folder_rounded,
      folder.name,
      (c) => showSheet(
        func: folderOptions,
        param: id,
      ),
    ),
    list: tasksIn(id, false) + foldersIn(id) + tasksIn(id, true),
  );
}

import 'package:flutter/material.dart';

import '../data.dart';
import '../functions.dart';
import '../task.dart';
import 'layers.dart';

Layer openFolder(dynamic parent) {
  parent as String;
  return Layer(
    trailing: (c) => [
      IconButton(
        icon: const Icon(Icons.create_new_folder_rounded),
        onPressed: () async {
          String str = parent == '/' ? '' : '/';
          String newName = await getInput('$parent$str', hintText: 'Start with /');
          for (var entry in tasks.entries) {
            if (entry.key.startsWith(parent) && entry.value.id != null) {}
          }
          Folder.defaultNew(name: newName).upload();
          refreshLayer();
        },
      ),
      IconButton(
        icon: const Icon(Icons.add_rounded),
        onPressed: () async {
          if (!tasks.containsKey(parent)) {
            await Folder.defaultNew(name: parent).upload();
          }
          Task.defaultNew(
            tasks[parent]!,
            name: await getInput(''),
          ).upload();
        },
      ),
    ],
    action: Setting(
      '',
      Icons.folder_rounded,
      folderName(parent),
      (p0) async {
        Navigator.of(p0).pop();
        String newParent = await getInput(parent, hintText: 'Rename folder');
        if (parent != newParent) {
          for (int i = 0; i < tasks.length; i++) {
            Folder folder = tasks.values.elementAt(i);
            if (folder.name.startsWith(parent) && folder.id != null) {
              folder.name = folder.name.replaceFirst(parent, newParent);
              folder.update();
              i = 0;
            }
          }
        }
        showSheet(func: openFolder, param: newParent, scroll: true);
      },
    ),
    leading: (c) => [
      parent == '/'
          ? Container()
          : IconButton(
              icon: const Icon(Icons.keyboard_return_rounded),
              onPressed: () {
                String prev = '/';
                for (int i = parent.length - 1; i > 0; i--) {
                  if (parent[i] == '/') {
                    prev = parent.replaceRange(i, null, '');
                  }
                }
                showSheet(
                  func: openFolder,
                  param: prev,
                  scroll: true,
                  hidePrev: c,
                );
              },
            )
    ],
    list: tasksIn(parent, false) + foldersIn(parent) + tasksIn(parent, true),
  );
}

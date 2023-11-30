import 'package:flutter/material.dart';

import '../data.dart';
import '../functions.dart';
import '../task.dart';
import 'layers.dart';
import 'open_folder.dart';

Layer folderOptions(dynamic parent) {
  Folder folder = tasks[parent] ?? Folder.defaultNew(name: parent);

  return Layer(
    action: Setting(
      '',
      Icons.folder_rounded,
      folderName(parent),
      (p0) async {
        Navigator.of(p0).pop();
        String newParent = await getInput(
          parent,
          hintText: 'Rename folder',
        );
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
    list: [
      Setting(
        '',
        Icons.colorize_rounded,
        folder.color ?? 'Adaptive',
        (p0) => showSheet(
          scroll: true,
          param: folder,
          func: (folder) {
            folder as Folder;
            return Layer(
              action: Setting(
                folder.color ?? 'Adaptive',
                Icons.colorize_rounded,
                '',
                (p0) {},
              ),
              list: [
                for (MapEntry<String, Color?> col in taskColors.entries)
                  Setting(
                    '',
                    Icons.circle,
                    col.key,
                    (p0) => (folder..color = col.key).update(),
                    iconColor: col.value,
                  )
              ],
            );
          },
        ),
        iconColor: taskColors[folder.color],
      ),
      Setting(
        '${folder.items.length}',
        Icons.numbers_rounded,
        'Items',
        (c) {},
      ),
      Setting(
        '',
        Icons.folder_off_rounded,
        folder.items.isEmpty ? 'Delete' : '**Delete**',
        (c) {
          Navigator.of(c).pop();
          folder.delete();
        },
      ),
    ],
  );
}

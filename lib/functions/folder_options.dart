import 'package:flutter/material.dart';
import '../data.dart';
import '../task.dart';
import '../template/functions.dart';
import '../template/layer.dart';
import 'structure.dart';

Future<Layer> folderOptions(dynamic id) async {
  Folder folder = structure[id] ?? Folder.defaultNew('/ERROR');
  return Layer(
    action: Setting(
      '',
      Icons.folder_rounded,
      folder.name,
      (p0) async {
        folder.name = await getInput(
          folder.name,
          hintText: 'Rename folder',
        );
        folder.update();
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
          func: (folder) async {
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
      folder.pin
          ? Setting(
              'Pinned',
              Icons.push_pin_rounded,
              '',
              (c) => (folder..pin = false).update(),
            )
          : Setting(
              'Pin',
              Icons.push_pin_outlined,
              '',
              (c) => (folder..pin = true).update(),
            ),
      Setting(
        'Connect',
        Icons.line_style_rounded,
        '${folder.nodes.length}',
        (c) => showSheet(
          func: allFolders,
          param: id,
          scroll: true,
          hidePrev: c,
        ),
      ),
      Setting(
        'Prefix',
        Icons.read_more_rounded,
        folder.prefix,
        (c) async {
          folder.prefix = await getInput(
            folder.prefix,
            hintText: 'Prefix',
          );
          await folder.update();
        },
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

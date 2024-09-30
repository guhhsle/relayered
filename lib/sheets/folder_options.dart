import 'package:flutter/material.dart';
import '../template/functions.dart';
import '../classes/folder.dart';
import '../template/layer.dart';
import '../template/tile.dart';
import 'structure.dart';
import '../data.dart';

Layer folderOptions(Map map) {
  Folder folder = structure[map['id']] ?? Folder.defaultNew('/ERROR');
  return Layer(
    action: Tile(
      folder.name,
      Icons.edit_rounded,
      '',
      onTap: (c) => getInput(folder.name, 'Rename folder').then((i) {
        folder.name = i;
        folder.update();
      }),
    ),
    list: [
      Tile(
        '',
        Icons.colorize_rounded,
        folder.color ?? 'Adaptive',
        iconColor: taskColors[folder.color],
        onTap: (p0) {
          showScrollSheet(
            (Map map) {
              Folder folder = map['folder'];
              return Layer(
                action: Tile(
                  folder.color ?? 'Adaptive',
                  Icons.colorize_rounded,
                  '',
                ),
                list: taskColors.entries.map((col) {
                  return Tile(
                    '',
                    Icons.circle,
                    col.key,
                    iconColor: col.value,
                    onTap: (c) {
                      (folder..color = col.key).update();
                    },
                  );
                }).toList(),
              );
            },
            {'folder': folder},
          );
        },
      ),
      folder.pin
          ? Tile('Pinned', Icons.push_pin_rounded, '', onTap: (c) {
              (folder..pin = false).update();
            })
          : Tile('Pin', Icons.push_pin_outlined, '', onTap: (c) {
              (folder..pin = true).update();
            }),
      Tile(
        'Connect',
        Icons.line_style_rounded,
        '${folder.nodes.length}',
        onTap: (c) {
          Navigator.of(c).pop();
          showScrollSheet(allFolders, {'id': map['id']});
        },
      ),
      Tile('Prefix', Icons.read_more_rounded, folder.prefix, onTap: (c) async {
        folder.prefix = await getInput(folder.prefix, 'Prefix');
        await folder.update();
      }),
      Tile('${folder.items.length}', Icons.numbers_rounded, 'Items'),
      Tile(
        '',
        Icons.folder_off_rounded,
        folder.items.isEmpty ? 'Delete' : '**Delete**',
        onTap: (c) {
          Navigator.of(c).pop();
          folder.delete();
        },
      ),
    ],
  );
}

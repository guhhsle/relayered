import 'package:flutter/material.dart';
import 'package:relayered/classes/database.dart';
import '../template/functions.dart';
import '../classes/folder.dart';
import '../functions/task.dart';
import '../template/layer.dart';
import '../data.dart';
import '../template/tile.dart';

Future<Layer> pinnedFolders(dynamic nothing) async {
  return Layer(
    action: Tile('Pinned', Icons.push_pin_rounded, ' '),
    list: (structure.values
            .where((e) => e.pin)
            .map(
              (e) => e.toTile,
            )
            .toList()) +
        (pinnedTasks().map((e) => e.toTile()).toList()),
    trailing: (c) => [
      IconButton(
        icon: const Icon(Icons.line_style_rounded),
        onPressed: () {
          Navigator.of(c).pop();
          showScrollSheet(allFolders);
        },
      ),
      IconButton(
        icon: const Icon(Icons.add_rounded),
        tooltip: t('New folder'),
        onPressed: () => getInput('', 'New folder').then((newName) {
          Folder newFolder = Folder.defaultNew(newName)..pin = true;
          newFolder.upload();
        }),
      ),
    ],
  );
}

Future<Layer> allFolders(Map map) async {
  Folder? folder = structure[map['id']];
  if (folder == null) {
    return Layer(
      action: Tile('New', Icons.add_rounded, '', onTap: (c) async {
        String newName = await getInput('', 'New folder');
        Folder newFolder = Folder.defaultNew(newName);
        newFolder.upload();
      }),
      list: structure.values.map((e) => e.toTile).toList(),
    );
  } else {
    return Layer(
      action: Tile('New', Icons.add_rounded, '', onTap: (c) async {
        String newName = await getInput('', 'New folder');
        Folder newFolder = Folder.defaultNew(newName, node: map['id']);
        await newFolder.upload();
        folder.nodes.add(newFolder.id!);
        Database.notify();
      }),
      list: structure.values
          .map((e) => e.toTile
            ..icon = folder.nodes.contains(e.id)
                ? Icons.folder_rounded
                : Icons.folder_outlined
            ..onTap = (c) async {
              if (folder.nodes.contains(e.id)) {
                folder.nodes.remove(e.id);
                e.nodes.remove(folder.id);
              } else if (e.id != null) {
                folder.nodes.add(e.id!);
                e.nodes.add(folder.id!);
              }
              await Future.wait([e.update(), folder.update()]);
            })
          .toList(),
    );
  }
}

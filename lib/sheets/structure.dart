import 'package:flutter/material.dart';
import '../template/functions.dart';
import '../classes/database.dart';
import '../classes/folder.dart';
import '../functions/task.dart';
import '../template/layer.dart';
import '../template/tile.dart';
import '../data.dart';

Layer pinnedFolders(Map non) {
  return Layer(
    action: Tile('Pinned', Icons.push_pin_rounded, ' '),
    list: [
      ...structure.values.where((e) => e.pin).map((e) => e.toTile),
      ...pinnedTasks().map((e) => e.toTile()),
    ],
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

Layer allFolders(Map map) {
  Folder? folder = structure[map['id']];
  if (folder == null) {
    return Layer(
      action: Tile('New', Icons.add_rounded, '', onTap: (c) async {
        String newName = await getInput('', 'New folder');
        Folder newFolder = Folder.defaultNew(newName);
        newFolder.upload();
      }),
      list: structure.values.map((e) => e.toTile),
    );
  } else {
    return Layer(
      action: Tile('New', Icons.add_rounded, '', onTap: (c) async {
        String newName = await getInput('', 'New folder');
        Folder newFolder = Folder.defaultNew(newName, node: map['id']);
        await newFolder.upload();
        folder.nodes.add(newFolder.id!);
        folder.update();
        Database.notify();
      }),
      list: structure.values.map((e) {
        Tile tile = e.toTile;
        if (folder.nodes.contains(e.id)) {
          tile.icon = Icons.folder_rounded;
        }
        tile.onTap = (c) {
          if (folder.nodes.contains(e.id)) {
            folder.nodes.remove(e.id);
            e.nodes.remove(folder.id);
          } else if (e.id != null) {
            folder.nodes.add(e.id!);
            e.nodes.add(folder.id!);
          }
          e.update();
          folder.update();
        };
        return tile;
      }),
    );
  }
}

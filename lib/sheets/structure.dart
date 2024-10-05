import 'package:flutter/material.dart';
import 'choose_folder.dart';
import 'open_folder.dart';
import '../template/functions.dart';
import '../classes/database.dart';
import '../classes/folder.dart';
import '../functions/task.dart';
import '../template/layer.dart';
import '../template/tile.dart';
import '../data.dart';

class PinnedFolders extends Layer {
  @override
  void construct() {
    listenTo(Database());
    action = Tile('Pinned', Icons.push_pin_rounded, ' ');
    list = [
      ...structure.values.where((e) => e.pin).map((e) => e.toTile()),
      ...pinnedTasks().map((e) => e.toTile()),
    ];
    trailing = [
      IconButton(
        icon: const Icon(Icons.line_style_rounded),
        onPressed: () {
          Navigator.of(context).pop();
          AllFolders().show();
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
    ];
  }
}

class AllFolders extends FolderBrowser {
  @override
  void onSelected(Folder chosen) {
    FolderLayer(chosen.id).show();
  }

  @override
  void construct() {
    scroll = true;
    action = Tile('New', Icons.add_rounded, '', () async {
      String newName = await getInput('', 'New folder');
      Folder newFolder = Folder.defaultNew(newName);
      newFolder.upload();
    });
    list = structure.values.map((e) => e.toTile());
  }
}

class FolderNodes extends FolderBrowser {
  String? folderID;
  FolderNodes(this.folderID);

  Folder get folder => structure[folderID] ?? Folder.defaultNew('/ERROR');

  @override
  void onSelected(Folder chosen) {
    if (folder.nodes.contains(chosen.id)) {
      folder.nodes.remove(chosen.id);
      chosen.nodes.remove(folder.id);
    } else {
      folder.nodes.add(chosen.id!);
      chosen.nodes.add(folder.id!);
    }

    chosen.update();
    folder.update();
  }

  @override
  bool isSelected(Folder chosen) => folder.nodes.contains(chosen.id);
}

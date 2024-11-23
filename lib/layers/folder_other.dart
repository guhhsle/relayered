import 'package:flutter/material.dart';
import 'folder_browser.dart';
import 'folder.dart';
import 'task.dart';
import '../template/functions.dart';
import '../classes/structure.dart';
import '../classes/database.dart';
import '../classes/folder.dart';
import '../template/layer.dart';
import '../template/tile.dart';

class PinnedLayer extends Layer {
  @override
  void construct() {
    listenTo(Database());
    action = Tile('Pinned', Icons.push_pin_rounded);
    final folders = Structure().pinnedFolders.map(
          (e) => e.toTile(() {
            Navigator.of(context).pop();
            FolderLayer(e.id).show();
          }),
        );
    final tasks = Structure().folders.map((f) {
      return f.items;
    }).expand((task) {
      return task;
    }).where((task) {
      return task.pinned;
    }).map((task) {
      return task.toTile(() {
        Navigator.of(context).pop();
        TaskLayer(task.id).show();
      });
    });
    list = [...folders, ...tasks];
    trailing = [
      IconButton(
        icon: const Icon(Icons.add_rounded),
        tooltip: t('New folder'),
        onPressed: () => getInput('', 'New pinned folder').then((newName) {
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
    action = Tile('New', Icons.add_rounded, '', () async {
      String newName = await getInput('', 'New folder');
      Folder newFolder = Folder.defaultNew(newName);
      newFolder.upload();
    });
    list = Structure().folders.map(
          (f) => f.toTile(() {
            Navigator.of(context).pop();
            FolderLayer(f.id).show();
          }),
        );
  }
}

class FolderNodes extends FolderBrowser {
  String? folderID;
  FolderNodes(this.folderID);

  Folder get folder => Structure().findFolder(folderID) ?? Folder.error();

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

import 'package:flutter/material.dart';
import 'folder_browser.dart';
import 'folder.dart';
import '../template/functions.dart';
import '../classes/structure.dart';
import '../classes/folder.dart';
import '../template/tile.dart';

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
    list = Structure().folders.map((folder) {
      return folder.toTile(() {
        Navigator.of(context).pop();
        FolderLayer(folder.id).show();
      });
    });
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

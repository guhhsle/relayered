import 'package:flutter/material.dart';
import '../template/functions.dart';
import '../classes/structure.dart';
import '../classes/database.dart';
import '../classes/folder.dart';
import '../template/layer.dart';
import '../template/tile.dart';

abstract class FolderBrowser extends Layer {
  @override
  void construct() {
    listenTo(Database());
    action = Tile('New', Icons.add_rounded, '', () async {
      String newName = await getInput('', 'New folder');
      Folder newFolder = Folder.defaultNew(newName);
      await newFolder.upload();
      onSelected(newFolder);
    });
    list = Structure().folders.map((f) {
      return f.toTile(() {
        Navigator.of(context).pop();
        onSelected(f);
      });
    });
  }

  void onSelected(Folder chosen);
  bool isSelected(Folder chosen) => false;
}

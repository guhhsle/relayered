import 'package:flutter/material.dart';
import 'folder.dart';
import 'folder_other.dart';
import '../template/functions.dart';
import '../classes/database.dart';
import '../template/tile.dart';
import '../functions.dart';
import '../data.dart';

class FolderOptions extends FolderLayer {
  FolderOptions(super.folderID);
  @override
  void construct() {
    listenTo(Database());
    action = Tile(folder.name, Icons.edit_rounded, '', () async {
      folder.name = await getInput(folder.name, 'Rename folder');
      folder.update();
    });

    list = [
      Tile.complex(
        '',
        Icons.colorize_rounded,
        folder.color ?? 'Adaptive',
        () async {
          final layer = ColorLayer(folder.color ?? 'Adaptive')..show();
          folder.color = await layer.completer.future;
          folder.update();
        },
        iconColor: taskColors[folder.color],
      ),
      if (folder.pin)
        Tile('Pinned', Icons.push_pin_rounded, '', () {
          (folder..pin = false).update();
        })
      else
        Tile('Pin', Icons.push_pin_outlined, '', () {
          (folder..pin = true).update();
        }),
      Tile(
        'Connect',
        Icons.line_style_rounded,
        '${folder.nodes.length}',
        () {
          Navigator.of(context).pop();
          FolderNodes(folderID).show();
        },
      ),
      Tile('Prefix', Icons.read_more_rounded, folder.prefix, () async {
        folder.prefix = await getInput(folder.prefix, 'Prefix');
        folder.update();
      }),
      Tile('${folder.items.length}', Icons.numbers_rounded, 'Items'),
      Tile(
        '',
        Icons.folder_off_rounded,
        folder.items.isEmpty ? 'Delete' : '**Delete**',
        () {
          Navigator.of(context).pop();
          folder.delete();
        },
      ),
    ];
  }
}

import 'package:flutter/material.dart';
import 'package:relayered/functions.dart';
import '../template/functions.dart';
import '../classes/folder.dart';
import '../template/layer.dart';
import '../template/tile.dart';
import 'structure.dart';
import '../data.dart';

Layer folderOptions(Layer l) {
  Folder folder = structure[l.parameters['id']] ?? Folder.defaultNew('/ERROR');
  l.action = Tile(
    folder.name,
    Icons.edit_rounded,
    '',
    () => getInput(folder.name, 'Rename folder').then((i) {
      folder.name = i;
      folder.update();
    }),
  );
  l.list = [
    Tile.complex(
      '',
      Icons.colorize_rounded,
      folder.color ?? 'Adaptive',
      () => getCustomColor(folder.color ?? 'Adaptive').then((col) {
        (folder..color = col).update();
      }),
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
        Navigator.of(l.context).pop();
        showScrollSheet(allFolders, l.parameters);
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
        Navigator.of(l.context).pop();
        folder.delete();
      },
    ),
  ];
  return l;
}

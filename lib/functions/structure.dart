import 'package:flutter/material.dart';
import '../data.dart';
import '../task.dart';
import '../template/functions.dart';
import '../template/layer.dart';
import 'task.dart';

Future<Layer> pinnedFolders(dynamic nothing) async {
  return Layer(
    action: Setting(
      'Pinned',
      Icons.push_pin_rounded,
      ' ',
      (c) {},
    ),
    list: (structure.values
            .where((e) => e.pin)
            .map(
              (e) => e.toSetting(),
            )
            .toList()) +
        (pinnedTasks().map((e) => e.toSetting()).toList()),
    trailing: (c) => [
      IconButton(
        onPressed: () => showSheet(
          func: allFolders,
          param: null,
          scroll: true,
          hidePrev: c,
        ),
        icon: const Icon(Icons.line_style_rounded),
      ),
      IconButton(
        onPressed: () async {
          String newName = await getInput('', hintText: 'New folder');
          Folder newFolder = Folder.defaultNew(newName)..pin = true;
          await newFolder.upload();
        },
        icon: const Icon(Icons.add_rounded),
        tooltip: t('New folder'),
      ),
    ],
  );
}

Future<Layer> allFolders(dynamic id) async {
  Folder? folder = structure[id];
  if (folder == null) {
    return Layer(
      action: Setting(
        'New',
        Icons.add_rounded,
        '',
        (c) async {
          String newName = await getInput('', hintText: 'New folder');
          Folder newFolder = Folder.defaultNew(newName);
          await newFolder.upload();
        },
      ),
      list: structure.values.map((e) => e.toSetting()).toList(),
    );
  } else {
    return Layer(
      action: Setting(
        'New',
        Icons.add_rounded,
        '',
        (c) async {
          String newName = await getInput('', hintText: 'New folder');
          Folder newFolder = Folder.defaultNew(newName, node: id);
          await newFolder.upload();
          folder.nodes.add(newFolder.id!);
          refreshLayer();
        },
      ),
      list: structure.values
          .map((e) => e.toSetting()
            ..icon = folder.nodes.contains(e.id) ? Icons.folder_rounded : Icons.folder_outlined
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

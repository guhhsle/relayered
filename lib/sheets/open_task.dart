import 'package:flutter/material.dart';
import 'package:relayered/functions.dart';
import '../functions/task.dart';
import '../classes/folder.dart';
import '../data.dart';
import '../pages/task.dart';
import '../classes/task.dart';
import '../template/functions.dart';
import '../template/layer.dart';
import '../template/tile.dart';

Layer openTask(Layer l) {
  Task task = Task.defaultNew(Folder.defaultNew('/ERROR'), name: 'ERROR');
  for (var folder in structure.values) {
    for (Task current in folder.items) {
      if (current.id == l.parameters['id']) task = current;
    }
  }
  l.action = Tile(task.name, Icons.edit, '', () async {
    final next = await getInput(task.name, 'Name');
    (task..name = next).update();
  });
  l.trailing = [
    IconButton(
      icon: Icon(task.checkedIcon),
      onPressed: () => (task..done = !task.done).update(),
    ),
  ];
  l.list = [
    Tile('', Icons.short_text_rounded, task.shortDesc, () {
      goToPage(TaskPage(task: task));
    }),
    Tile.complex(
      '',
      Icons.colorize_rounded,
      task.color,
      () => getCustomColor(task.color).then((col) {
        (task..color = col).update();
      }),
      iconColor: taskColors[task.color],
    ),
    Tile(
      '',
      Icons.calendar_today_rounded,
      task.date(year: true, month: true),
      () => showSheet(
        (Layer l) async {
          l.action = Tile(
            'Add date',
            Icons.insert_invitation_rounded,
            '',
            () => task.pickDate(l.context).then((due) {
              if (due == null) return;
              task.dues.add(due);
              task.update();
            }),
          );
          l.list = task.dues.map((due) {
            return Tile.complex(
              formatDate(due, year: false),
              Icons.event_busy_rounded,
              '',
              () {
                task.dues.remove(due);
                task.update();
              },
              secondary: () {
                task.dues.remove(due);
                task.update();
              },
            );
          });
          return l;
        },
      ),
    ),
    Tile('', task.pinnedIcon, 'Pin${task.pinned ? 'ned' : ''}', () {
      (task..pinned = !task.pinned).update();
    }),
    Tile.complex(
      '',
      Icons.folder_outlined,
      task.path.name,
      () => task.path.open(context: l.context),
      onHold: () {
        Navigator.of(l.context).pop();
        showScrollSheet((Layer l) {
          l.action = Tile('New', Icons.add_rounded, '', () async {
            String newName = await getInput('', 'New folder');
            Folder newFolder = Folder.defaultNew(newName);
            newFolder.upload();
          });
          l.list = structure.values.map((e) => e.toTile
            ..onTap = () {
              Navigator.of(l.context).pop();
              Map json = task.toJson;
              task.delete();
              moveTask(json, e.id);
            });
        });
      },
    ),
    Tile('', Icons.delete_forever_rounded, 'Delete', () => task.delete()),
  ];
  return l;
}

void moveTask(Map taskMap, String? folderID) {
  Task.fromJson(taskMap, structure[folderID]!).upload();
}

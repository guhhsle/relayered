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

Layer openTask(Map map) {
  Task task = Task.defaultNew(Folder.defaultNew('/ERROR'), name: 'ERROR');
  for (var folder in structure.values) {
    for (Task current in folder.items) {
      if (current.id == map['id']) task = current;
    }
  }
  return Layer(
    action: Tile(task.name, Icons.edit, '', onTap: (c) async {
      final next = await getInput(task.name, 'Name');
      (task..name = next).update();
    }),
    trailing: (c) => [
      IconButton(
        icon: Icon(task.checkedIcon),
        onPressed: () => (task..done = !task.done).update(),
      ),
    ],
    list: [
      Tile('', Icons.short_text_rounded, task.shortDesc, onTap: (c) {
        goToPage(TaskPage(task: task));
      }),
      Tile(
        '',
        Icons.colorize_rounded,
        task.color,
        iconColor: taskColors[task.color],
        onTap: (c) => getCustomColor(task.color).then((col) {
          (task..color = col).update();
        }),
      ),
      Tile(
        '',
        Icons.calendar_today_rounded,
        task.date(year: true, month: true),
        onTap: (c) => showSheet(
          (Map non) async {
            return Layer(
              action: Tile(
                'Add date',
                Icons.insert_invitation_rounded,
                '',
                onTap: (c) => task.pickDate(c).then((due) {
                  if (due == null) return;
                  task.dues.add(due);
                  task.update();
                }),
              ),
              list: task.dues.map((due) {
                return Tile(
                  formatDate(due, year: false),
                  Icons.event_busy_rounded,
                  '',
                  onTap: (c) {
                    task.dues.remove(due);
                    task.update();
                  },
                  secondary: (c) {
                    task.dues.remove(due);
                    task.update();
                  },
                );
              }).toList(),
            );
          },
        ),
      ),
      Tile(
        '',
        task.pinnedIcon,
        'Pin${task.pinned ? 'ned' : ''}',
        onTap: (c) => (task..pinned = !task.pinned).update(),
      ),
      Tile(
        '',
        Icons.folder_outlined,
        task.path.name,
        onTap: (c) => task.path.open(context: c),
        onHold: (c) {
          Navigator.of(c).pop();
          showScrollSheet(
            (dynamic d) async => Layer(
              action: Tile('New', Icons.add_rounded, '', onTap: (c) async {
                String newName = await getInput('', 'New folder');
                Folder newFolder = Folder.defaultNew(newName);
                await newFolder.upload();
              }),
              list: structure.values.map((e) => e.toTile
                ..onTap = (c) {
                  Navigator.of(c).pop();
                  Map json = task.toJson;
                  task.delete();
                  moveTask(json, e.id);
                }),
            ),
          );
        },
      ),
      Tile('', Icons.delete_forever_rounded, 'Delete', onTap: (c) {
        task.delete();
      })
    ],
  );
}

void moveTask(Map taskMap, String? folderID) {
  Task.fromJson(taskMap, structure[folderID]!).upload();
}

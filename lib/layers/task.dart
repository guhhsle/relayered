import 'package:flutter/material.dart';
import 'move_task.dart';
import 'task_date.dart';
import 'folder.dart';
import '../template/functions.dart';
import '../classes/structure.dart';
import '../classes/database.dart';
import '../template/layer.dart';
import '../template/tile.dart';
import '../classes/task.dart';
import '../pages/task.dart';
import '../functions.dart';
import '../data.dart';

class TaskLayer extends Layer {
  String? taskID;
  TaskLayer(this.taskID);
  Task get task => Structure().findTask(taskID) ?? Task.error();

  @override
  void construct() {
    listenTo(Database());
    action = Tile(task.name, Icons.notes_rounded, '', () {
      goToPage(TaskPage(task: task));
    });
    trailing = [
      IconButton(
        icon: Icon(task.checkedIcon),
        onPressed: () => (task..done = !task.done).update(),
      ),
    ];
    list = [
      Tile.complex(
        '',
        Icons.colorize_rounded,
        task.color,
        () async {
          final layer = ColorLayer(task.color)..show();
          task.color = await layer.completer.future;
          task.update();
        },
        iconColor: taskColors[task.color],
      ),
      Tile('', Icons.calendar_today_rounded, task.date(true, true),
          () => TaskDate(taskID).show()),
      Tile('', task.pinnedIcon, 'Pin${task.pinned ? 'ned' : ''}', () {
        (task..pinned = !task.pinned).update();
      }),
      Tile.complex(
        '',
        Icons.folder_outlined,
        task.path.name,
        () {
          Navigator.of(context).pop();
          FolderLayer(task.path.id).show();
        },
        onHold: () {
          Navigator.of(context).pop();
          MoveTask(taskID).show();
        },
      ),
      Tile('', Icons.delete_forever_rounded, 'Delete', () => task.delete()),
    ];
  }
}

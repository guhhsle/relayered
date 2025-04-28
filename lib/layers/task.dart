import 'package:flutter/material.dart';
import 'move_task.dart';
import 'task_date.dart';
import 'folder.dart';
import '../classes/structure.dart';
import '../classes/database.dart';
import '../template/layer.dart';
import '../template/tile.dart';
import '../classes/task.dart';
import '../functions.dart';
import '../data.dart';

class TaskLayer extends Layer {
  String? taskID;
  TaskLayer(this.taskID);
  Task get task => Structure().findTask(taskID) ?? Task.error();

  @override
  void construct() {
    listenTo(Database());
    action = Tile.complex(
      task.path.name,
      Icons.folder_outlined,
      '',
      () {
        Navigator.of(context).pop();
        FolderLayer(task.path.id).show();
      },
      onHold: () {
        Navigator.of(context).pop();
        MoveTask(taskID).show();
      },
    );
    trailing = [
      IconButton(
        icon: Icon(task.pinnedIcon),
        onPressed: task.unPin,
      )
    ];
    list = [
      Tile.complex(
        '',
        Icons.colorize_rounded,
        task.color,
        () => ColorLayer(task.color, onSelected: (c) {
          (task..color = c).update();
        }).show(),
        iconColor: taskColors[task.color],
      ),
      Tile('', Icons.calendar_today_rounded, task.date(true, true),
          () => TaskDate(taskID).show()),
      Tile('', Icons.delete_forever_rounded, 'Delete', () => task.delete()),
    ];
  }
}

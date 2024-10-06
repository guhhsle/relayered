import 'package:flutter/material.dart';
import 'task.dart';
import '../classes/database.dart';
import '../template/tile.dart';
import '../functions.dart';

class TaskDate extends TaskLayer {
  TaskDate(super.taskID);

  @override
  void construct() {
    listenTo(Database());
    action = Tile('Add date', Icons.insert_invitation_rounded, '', () async {
      final due = await showDatePicker(
        builder: (context, child2) => child2!,
        context: context,
        firstDate: DateTime(DateTime.now().year - 1),
        lastDate: DateTime(DateTime.now().year + 5),
      );
      if (due == null) return;
      task.dues.add(due);
      task.update();
    });
    list = task.dues.map((due) {
      return Tile.complex(
        due.prettify(false),
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
  }
}

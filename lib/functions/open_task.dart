import 'package:flutter/material.dart';

import '../data.dart';
import '../functions.dart';
import '../pages/task.dart';
import '../task.dart';
import '../widgets/calendar.dart';
import 'layers.dart';
import 'open_folder.dart';

Layer openTask(dynamic id) {
  Task task = Task.defaultNew(Folder.defaultNew('/ERROR'), name: 'ERROR');
  for (MapEntry<String, Folder> map in structure.entries) {
    for (Task current in map.value.items) {
      if (current.id == id) task = current;
    }
  }
  return Layer(
    action: Setting(
      task.name,
      Icons.edit,
      '',
      (p0) async => (task..name = await getInput(task.name)).update(),
    ),
    trailing: (c) => [
      IconButton(
        icon: Icon(task.checked()),
        onPressed: () => (task..done = !task.done).update(),
      ),
    ],
    list: [
      Setting(
        '',
        Icons.short_text_rounded,
        task.shortDesc().substring(0, task.shortDesc().length > 20 ? 20 : null),
        (p0) => goToPage(TaskPage(task: task)),
      ),
      Setting(
        '',
        Icons.colorize_rounded,
        task.color,
        (p0) => showSheet(
          scroll: true,
          param: task,
          func: (task) {
            task as Task;
            return Layer(
              action: Setting(
                task.color,
                Icons.colorize_rounded,
                '',
                (p0) {},
              ),
              list: [
                for (MapEntry<String, Color?> col in taskColors.entries)
                  Setting(
                    '',
                    Icons.circle,
                    col.key,
                    (p0) => (task..color = col.key).update(),
                    iconColor: col.value,
                  )
              ],
            );
          },
        ),
        iconColor: taskColors[task.color],
      ),
      Setting(
        '',
        Icons.calendar_today_rounded,
        task.date(year: true, month: true),
        (p0) => pickDate(task, p0),
      ),
      Setting(
        '',
        task.pinned ? Icons.push_pin_rounded : Icons.push_pin_outlined,
        'Pin${task.pinned ? 'ned' : ''}',
        (p0) => (task..pinned = !task.pinned).update(),
      ),
      Setting(
        '',
        Icons.folder_outlined,
        task.path.name,
        (p0) => showSheet(
          func: openFolder,
          scroll: true,
          param: task.path.id,
          hidePrev: p0,
        ),
      ),
      Setting(
        '',
        Icons.delete_forever_rounded,
        'Delete',
        (p0) => task.delete(),
      )
    ],
  );
}

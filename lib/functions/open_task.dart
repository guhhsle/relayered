// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:relayered/functions/task.dart';
import '../classes/folder.dart';
import '../data.dart';
import '../pages/task.dart';
import '../classes/task.dart';
import '../template/functions.dart';
import '../template/layer.dart';
import '../widgets/calendar.dart';
import 'open_folder.dart';

Future<Layer> openTask(dynamic id) async {
  Task task = Task.defaultNew(
    Folder.defaultNew('/ERROR'),
    name: 'ERROR',
  );
  for (var map in structure.entries) {
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
        icon: Icon(task.checkedIcon),
        onPressed: () => (task..done = !task.done).update(),
      ),
    ],
    list: [
      Setting(
        '',
        Icons.short_text_rounded,
        task.shortDesc,
        (p0) => goToPage(TaskPage(task: task)),
      ),
      Setting(
        '',
        Icons.colorize_rounded,
        task.color,
        (p0) => showSheet(
          scroll: true,
          param: task,
          func: (task) async {
            task as Task;
            return Layer(
              action: Setting(
                task.color,
                Icons.colorize_rounded,
                '',
                (p0) {},
              ),
              list: taskColors.entries.map((col) {
                return Setting(
                  '',
                  Icons.circle,
                  col.key,
                  (p0) => (task..color = col.key).update(),
                  iconColor: col.value,
                );
              }).toList(),
            );
          },
        ),
        iconColor: taskColors[task.color],
      ),
      Setting(
        '',
        Icons.calendar_today_rounded,
        task.date(year: true, month: true),
        (p0) {
          showSheet(
            func: (non) async {
              return Layer(
                action: Setting(
                  'Add date',
                  Icons.insert_invitation_rounded,
                  '',
                  (context) async {
                    var due = await pickDate(task, context);
                    if (due != null) {
                      task.dues.add(due);
                      await task.update();
                    }
                  },
                ),
                list: task.dues.map((due) {
                  return Setting(
                    formatDate(due, year: false),
                    Icons.event_busy_rounded,
                    '',
                    (c) {
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
          );
        },
      ),
      Setting(
        '',
        task.pinnedIcon,
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
        onHold: (p0) => showSheet(
          func: (dynamic d) async => Layer(
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
            list: structure.values
                .map((e) => e.toSetting
                  ..onTap = (c) async {
                    Navigator.of(c).pop();
                    Map json = task.toJson;
                    await Future.wait([
                      task.delete(),
                      moveTask(json, e.id),
                    ]);
                  })
                .toList(),
          ),
          param: null,
          scroll: true,
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

Future<void> moveTask(Map taskMap, String? folderID) async {
  await Task.fromJson(taskMap, structure[folderID]!).upload();
}

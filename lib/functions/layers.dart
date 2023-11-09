// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:flutter/material.dart';

import '../data.dart';
import '../functions.dart';
import '../pages/task.dart';
import '../task.dart';
import '../widgets/calendar.dart';
import '../widgets/sheet_model.dart';
import '../widgets/sheet_scroll.dart';

class Layer {
  Setting action;
  List<Setting> list;
  List<Widget> leading, trailing;

  Layer({
    required this.action,
    required this.list,
    this.leading = const [SizedBox()],
    this.trailing = const [SizedBox()],
  });
}

ValueNotifier<List<Layer>> layers = ValueNotifier([]);

void showSheet({
  required Layer Function(dynamic) func,
  required dynamic param,
  bool scroll = false,
  BuildContext? hidePrev,
}) {
  if (hidePrev != null) {
    Navigator.of(hidePrev).pop();
  }
  showModalBottomSheet(
    context: navigatorKey.currentContext!,
    isScrollControlled: true,
    barrierColor: Colors.black.withOpacity(0.3),
    builder: (context) {
      if (scroll) {
        return SheetScrollModel(func: func, param: param);
      }
      return SheetModel(func: func, param: param);
    },
  );
}

List<Setting> foldersIn(String parent) {
  List<Setting> list = [];
  for (int i = 0; i < tasks.length; i++) {
    String str = tasks.keys.elementAt(i);
    String format = str.replaceFirst(parent, '');
    int index = format.indexOf('/');
    if (str.startsWith(parent) && str != parent && index < 1) {
      list.add(
        Setting(
            format.replaceAll('/', ''),
            Icons.folder_outlined,
            '',
            (p0) => showSheet(
                  func: openFolder,
                  param: str,
                  scroll: true,
                  hidePrev: pf['stackLayers'] ? null : p0,
                ), onHold: (c) {
          if (tasks[str]!.items.isEmpty) {
            tasks[str]!.delete();
          }
        }),
      );
    }
  }

  return list;
}

List<Setting> tasksIn(String parent, bool done) {
  if (tasks[parent] == null) return [];
  List<Setting> list = [];

  for (Task task in tasks[parent]!.items) {
    if (task.done == done) {
      list.add(
        Setting(
          task.name,
          task.checked(),
          '',
          (p0) => showSheet(
            func: openTask,
            param: task.id,
          ),
          iconColor: taskColors[task.color],
          secondary: (c) {
            (task..done = !task.done).update();
          },
          onHold: (c) => goToPage(TaskPage(task: task)),
        ),
      );
    }
  }

  return list;
}

String random() {
  return '${Random().nextInt(999)}';
}

Layer openFolder(dynamic parent) {
  parent as String;
  return Layer(
    trailing: [
      IconButton(
        icon: const Icon(Icons.create_new_folder_rounded),
        onPressed: () async {
          String str = parent == '/' ? '' : '/';
          String newName = await getInput('$parent$str', hintText: 'Start with /');
          Folder.defaultNew(name: newName).upload();
          refreshLayer();
        },
      ),
      IconButton(
        icon: const Icon(Icons.add_rounded),
        onPressed: () async {
          if (!tasks.containsKey(parent)) {
            await Folder.defaultNew(name: parent).upload();
          }
          Task.defaultNew(
            tasks[parent]!,
            name: await getInput(''),
          ).upload();
        },
      ),
    ],
    action: Setting(
      '',
      Icons.folder_rounded,
      parent,
      (p0) async {
        Navigator.of(p0).pop();
        String newParent = await getInput(parent, hintText: 'Rename folder');
        await (tasks[parent]!..name = newParent).update();
        showSheet(func: openFolder, param: newParent, scroll: true);
      },
    ),
    list: (parent == '/'
            ? <Setting>[]
            : [
                Setting(
                  '',
                  Icons.keyboard_return_rounded,
                  '',
                  (c) {
                    String prev = '/';
                    for (int i = parent.length - 1; i > 0; i--) {
                      if (parent[i] == '/') {
                        prev = parent.replaceRange(i, null, '');
                      }
                    }
                    showSheet(
                      func: openFolder,
                      param: prev,
                      scroll: true,
                      hidePrev: c,
                    );
                  },
                ),
              ]) +
        tasksIn(parent, false) +
        foldersIn(parent) +
        tasksIn(parent, true),
  );
}

Layer openTask(dynamic id) {
  Task task = Task.defaultNew(Folder.defaultNew(name: '/ERROR'), name: 'ERROR');
  for (MapEntry<String, Folder> map in tasks.entries) {
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
    trailing: [
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
            }),
        iconColor: colors[task.color],
      ),
      Setting(
        '',
        Icons.calendar_today_rounded,
        task.date(year: true),
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
          param: task.path.name,
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

import 'package:flutter/material.dart';

import '../data.dart';
import '../functions.dart';
import '../pages/task.dart';
import '../task.dart';
import '../widgets/sheet_model.dart';
import '../widgets/sheet_scroll.dart';
import 'open_folder.dart';
import 'open_task.dart';

class Layer {
  final Setting action;
  final List<Setting> list;
  List<Widget> Function(BuildContext)? leading, trailing;

  Layer({
    required this.action,
    required this.list,
    this.leading,
    this.trailing,
  });
}

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
            folderName(str),
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

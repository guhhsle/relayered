import 'package:flutter/material.dart';

import '../data.dart';
import '../task.dart';
import '../widgets/sheet_model.dart';
import '../widgets/sheet_scroll.dart';

class Layer {
  final Setting action;
  final List<Setting> list;
  List<Widget> Function(BuildContext)? trailing;

  Layer({
    required this.action,
    required this.list,
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

List<Setting> foldersIn(String id) {
  if (structure[id] == null) return [];
  List<Setting> list = [];

  for (String nodeId in structure[id]!.nodes) {
    for (Folder node in structure.values.where((e) => e.id == nodeId)) {
      list.add(node.toSetting());
    }
  }

  return list;
}

List<Setting> tasksIn(String id, bool done) {
  if (structure[id] == null) return [];
  List<Setting> list = [];

  for (Task task in structure[id]!.items) {
    if (task.done == done) {
      list.add(task.toSetting());
    }
  }

  return list;
}

List<Task> pinnedTasks() {
  List<Task> result = [];
  for (Folder folder in structure.values) {
    for (Task task in folder.items) {
      if (task.pinned) result.add(task);
    }
  }
  return result;
}

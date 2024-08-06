import 'package:flutter/material.dart';
import 'package:relayered/data.dart';

import '../classes/database.dart';
import '../classes/folder.dart';
import '../classes/task.dart';
import '../template/layer.dart';

Stream<Layer> allTasks(dynamic non) async* {
  yield allTasksLayer(0);
  yield* Database.stream.map(allTasksLayer);
}

int allTasksFilter = 0;

Layer allTasksLayer(dynamic non) {
  List<Task> allTasks = [];
  for (Folder folder in structure.values) {
    for (Task task in folder.items) {
      if (allTasksFilter == 1 && task.done) continue;
      if (allTasksFilter == 2 && !task.done) continue;
      allTasks.add(task);
    }
  }
  allTasks.sort((a, b) => a.name.compareTo(b.name));
  return Layer(
    action: Setting(
      [
        'All tasks',
        'Pending tasks',
        'Done tasks',
      ][allTasksFilter],
      Icons.filter_list_rounded,
      '',
      (c) {
        allTasksFilter = (allTasksFilter + 1) % 3;
        refreshLayer();
      },
    ),
    list: allTasks.map((task) => task.toSetting()).toList(),
  );
}

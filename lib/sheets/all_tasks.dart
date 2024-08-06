import 'package:flutter/material.dart';
import 'package:relayered/data.dart';

import '../classes/database.dart';
import '../classes/folder.dart';
import '../classes/task.dart';
import '../template/layer.dart';

Stream<Layer> allTasks(dynamic non) async* {
  yield* Database.stream.map(allTasksLayer);
}

Layer allTasksLayer(dynamic non) {
  List<Task> allTasks = [];
  for (Folder folder in structure.values) {
    for (Task task in folder.items) {
      allTasks.add(task);
    }
  }
  allTasks.sort((a, b) => a.name.compareTo(b.name));
  return Layer(
    action: Setting(
      'All tasks',
      Icons.fiber_manual_record_rounded,
      '',
      (c) {},
    ),
    list: allTasks.map((task) => task.toSetting()).toList(),
  );
}

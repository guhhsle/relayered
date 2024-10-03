import 'package:flutter/material.dart';
import '../classes/database.dart';
import '../template/prefs.dart';
import '../classes/folder.dart';
import '../template/layer.dart';
import '../template/tile.dart';
import '../classes/task.dart';
import '../data.dart';

Stream<Layer> allTasks(Layer l) async* {
  yield allTasksLayer(l);
  yield* Database.stream.map((e) => allTasksLayer(l));
}

const filters = ['All', 'Pending', 'Done'];
String selFilter = 'All';

Layer allTasksLayer(Layer l) {
  List<Task> allTasks = [];
  for (Folder folder in structure.values) {
    for (Task task in folder.items) {
      if (selFilter == 'Pending' && task.done) continue;
      if (selFilter == 'Done' && !task.done) continue;
      allTasks.add(task);
    }
  }
  allTasks.sort((a, b) => a.name.compareTo(b.name));
  l.action = Tile('$selFilter tasks', Icons.filter_list_rounded, '', () {
    selFilter = filters[(filters.indexOf(selFilter) + 1) % 3];
    Preferences.notify();
  });
  l.list = allTasks.map((task) => task.toTile());
  return l;
}

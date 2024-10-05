import 'package:flutter/material.dart';
import '../classes/database.dart';
import '../template/prefs.dart';
import '../classes/folder.dart';
import '../template/layer.dart';
import '../template/tile.dart';
import '../classes/task.dart';
import '../data.dart';

class AllTasks extends Layer {
  static const filters = ['All', 'Pending', 'Done'];
  static String selFilter = 'All';
  @override
  void construct() {
    listenTo(Database());
    List<Task> allTasks = [];
    for (Folder folder in structure.values) {
      for (Task task in folder.items) {
        if (selFilter == 'Pending' && task.done) continue;
        if (selFilter == 'Done' && !task.done) continue;
        allTasks.add(task);
      }
    }
    allTasks.sort((a, b) => a.name.compareTo(b.name));
    action = Tile('$selFilter tasks', Icons.filter_list_rounded, '', () {
      selFilter = filters[(filters.indexOf(selFilter) + 1) % 3];
      Preferences.notify();
    });
    list = allTasks.map((task) => task.toTile());
  }
}

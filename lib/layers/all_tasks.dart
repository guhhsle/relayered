import 'package:flutter/material.dart';
import 'folder_other.dart';
import 'task.dart';
import '../classes/structure.dart';
import '../classes/database.dart';
import '../template/prefs.dart';
import '../classes/folder.dart';
import '../template/layer.dart';
import '../template/tile.dart';
import '../classes/task.dart';

class AllTasks extends Layer {
  static const filters = ['All', 'Pending', 'Done'];
  static String selFilter = 'All';
  @override
  construct() {
    listenTo(Database());
    List<Task> allTasks = [];
    for (Folder folder in Structure().folders) {
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
    list = allTasks.map((task) {
      return task.toTile(() {
        Navigator.of(context).pop();
        TaskLayer(task.id).show();
      });
    });
    trailing = [
      IconButton(
        icon: const Icon(Icons.folder_rounded),
        onPressed: () {
          Navigator.of(context).pop();
          AllFolders().show();
        },
      ),
    ];
  }
}

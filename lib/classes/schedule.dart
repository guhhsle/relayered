import 'package:flutter/material.dart';
import 'package:relayered/classes/structure.dart';
import 'month.dart';
import 'task.dart';
import '../functions.dart';
import '../data.dart';

class Schedule {
  BuildContext context;
  List<List<MonthContainer>> list = [[], [], [], []];

  Schedule({required this.context}) {
    list = [[], [], [], []];
    fetchAllTasks();
  }

  void sortTasks(List<MapEntry<DateTime?, Task>> list, int reverse) =>
      list.sort((a, b) {
        int i = 0;
        if (a.key == null && b.key == null) {
        } else if (a.key == null && b.key != null) {
          i = 1;
        } else if (a.key != null && b.key == null) {
          i = -1;
        } else {
          i = a.key!.compareTo(b.key!);
        }
        if (i == 0) return a.value.name.compareTo(b.value.name);
        return reverse * i;
      });

  void addTaskToList(
    MapEntry<DateTime?, Task> entry,
    List<MonthContainer> list, {
    int reverse = 1,
  }) {
    for (var monthContainer in list) {
      if (monthContainer.during(entry)) {
        monthContainer.list.add(MapEntry(entry.key, entry.value));
        sortTasks(monthContainer.list, reverse);
        return;
      }
    }
    list.add(MonthContainer.from(
      MapEntry(entry.key, entry.value),
      cs: Theme.of(context).colorScheme,
    ));
    list.sort((a, b) => reverse * a.compareTo(b));
  }

  void fetchAllTasks() {
    list[0].add(MonthContainer(
      name: ' ',
      year: 9999,
      month: 9999,
      list: [],
      color: Theme.of(context).colorScheme.surface,
    ));

    for (final folder in Structure().folders) {
      if (!folder.show) continue;
      for (final task in folder.items) {
        if (task.done && !Pref.showDone.value && !task.pinned) continue;
        if (task.hasDue && Pref.showCalendar.value) {
          for (int i = 0; i < task.dues.length; i++) {
            int comparation = task.dues[i].compareTo(today());
            if (Pref.showPinned.value &&
                (comparation == 0 || (task.pinned && i == 0))) {
              list[0][0].list.add(MapEntry(task.dues[i], task));
            } else {
              addTaskToList(
                MapEntry(task.dues[i], task),
                list[{-1: 2, 1: 1}[comparation] ?? 0],
                reverse: comparation,
              );
            }
          }
        } else {
          if (task.pinned && Pref.showPinned.value) {
            list[0][0].list.add(MapEntry(null, task));
          } else if (Pref.showFolders.value) {
            addTaskToList(MapEntry(null, task), list[3]);
          }
        }
      }
    }
    if (list[0][0].list.isEmpty) {
      list[0].clear();
    } else {
      sortTasks(list[0][0].list, 1);
    }
    list[3].sort((a, b) => a.name.compareTo(b.name));
  }
}

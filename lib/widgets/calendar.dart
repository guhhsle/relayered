import 'package:flutter/material.dart';
import '../functions/folder_options.dart';
import '../functions/open_folder.dart';
import '../data.dart';
import '../functions/task.dart';
import '../task.dart';
import '../template/data.dart';
import '../template/functions.dart';
import '../template/layer.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

Map<String, Color> monthColors = {
  'January': Colors.white,
  'February': Colors.pink,
  'March': Colors.purple,
  'April': Colors.yellow,
  'May': Colors.green,
  'June': Colors.orange,
  'July': Colors.cyan,
  'August': Colors.blue,
  'September': Colors.orange,
  'October': Colors.red,
  'November': Colors.brown,
  'December': Colors.red,
};

class MonthContainer {
  String name;
  Color color;
  int year, month;
  List<MapEntry<DateTime?, Task>> list;
  Folder? folder;

  MonthContainer({
    required this.name,
    required this.year,
    required this.color,
    required this.month,
    required this.list,
    this.folder,
  });

  bool during(MapEntry<DateTime?, Task> entry) {
    if (entry.key == null) return entry.value.path.name == name;
    if (entry.key!.month != month) return false;
    if (entry.key!.year != year) return false;
    return true;
  }

  static MonthContainer from(MapEntry<DateTime?, Task> entry,
      {ColorScheme? cs}) {
    if (entry.key != null) {
      return MonthContainer(
        name: monthColors.keys.elementAt(entry.key!.month - 1),
        year: entry.key!.year,
        month: entry.key!.month,
        list: [entry],
        color: monthColors.values.elementAt(entry.key!.month - 1),
      );
    }
    return MonthContainer(
      name: entry.value.path.name,
      year: 9999,
      month: 12,
      list: [entry],
      color: taskColors[entry.value.path.color] ?? (cs!.primary),
      folder: entry.value.path,
    );
  }

  int compareTo(MonthContainer other) {
    if (year != other.year) return year.compareTo(other.year);
    return month.compareTo(other.month);
  }

  Map<int, MonthContainer> toMap() => {year * 100 + month: this};
}

class _CalendarState extends State<Calendar> {
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

  @override
  Widget build(BuildContext context) {
    List<List<MonthContainer>> fetchAllTasks() {
      List<List<MonthContainer>> list = [[], [], [], []];
      list[0].add(MonthContainer(
        name: ' ',
        year: 9999,
        month: 9999,
        list: [],
        color: Theme.of(context).colorScheme.surface,
      ));

      for (var folder in structure.values) {
        bool ignored = false;
        for (var str in pf['ignore']) {
          if (folder.name.startsWith(str)) ignored = true;
        }
        if (ignored) continue;
        for (var task in folder.items) {
          if (task.done && !pf['showDone'] && !task.pinned) continue;
          if (task.hasDue && pf['showCalendar']) {
            for (int i = 0; i < task.dues.length; i++) {
              int comparation = task.dues[i].compareTo(today());
              if (pf['showPinned'] &&
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
            if (task.pinned && pf['showPinned']) {
              list[0][0].list.add(MapEntry(null, task));
            } else if (pf['showFolders']) {
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
      return list;
    }

    return RefreshIndicator(
      onRefresh: sync,
      child: StreamBuilder(
        stream: streamNote.snapshots(),
        builder: (context, snap) {
          List<List<MonthContainer>> data = fetchAllTasks();
          return ListView.builder(
            itemCount: data.length,
            physics: scrollPhysics,
            padding: const EdgeInsets.only(bottom: 64),
            itemBuilder: (context, i) {
              return Card(
                margin: const EdgeInsets.only(
                    top: 8, left: 8, right: 8, bottom: 32),
                shape: const RoundedRectangleBorder(borderRadius: customRadius),
                shadowColor: Colors.transparent,
                color: Theme.of(context).primaryColor.withOpacity(0.08),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data[i].length,
                  shrinkWrap: true,
                  itemBuilder: (context, j) {
                    return InkWell(
                      borderRadius: customRadius,
                      onTap: () => data[i][j].folder == null
                          ? {}
                          : showSheet(
                              func: openFolder,
                              param: data[i][j].folder!.id,
                              scroll: true,
                            ),
                      onLongPress: () => data[i][j].folder == null
                          ? {}
                          : showSheet(
                              func: folderOptions,
                              param: data[i][j].folder!.id,
                            ),
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 8,
                        ),
                        shape: const RoundedRectangleBorder(
                            borderRadius: customRadius),
                        shadowColor: Colors.transparent,
                        color: data[i][j].color.withOpacity(0.3),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            children: [
                              Text(t(data[i][j].name)),
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: data[i][j].list.length,
                                itemBuilder: (context, k) {
                                  MapEntry<DateTime?, Task> entry =
                                      data[i][j].list[k];
                                  String prefix = '';
                                  if (entry.value.path.prefix != '') {
                                    prefix = '${entry.value.path.prefix} ';
                                  }
                                  String date = '${formatDate(
                                    entry.key,
                                    year: false,
                                    month: false,
                                  )}  ';
                                  if (date == '  ') date += '  ';
                                  return entry.value
                                      .toSetting(
                                        title:
                                            '$date$prefix${entry.value.name}',
                                      )
                                      .toTile(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

Future<DateTime?> pickDate(Task task, BuildContext context) => showDatePicker(
      builder: (context, child2) => child2!,
      context: context,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 5),
    );

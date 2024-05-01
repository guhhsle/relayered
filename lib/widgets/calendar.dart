import 'package:flutter/material.dart';
import '../functions/folder_options.dart';
import '../functions/open_folder.dart';
import '../data.dart';
import '../functions/task.dart';
import '../task.dart';
import '../template/data.dart';
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
  List<Task> list;
  Folder? folder;

  MonthContainer({
    required this.name,
    required this.year,
    required this.color,
    required this.month,
    required this.list,
    this.folder,
  });

  bool duringTask(Task task) {
    if (task.due == null) return name == task.path.name;
    if (task.due!.month != month) return false;
    if (task.due!.year != year) return false;
    return true;
  }

  static MonthContainer fromTask(Task task, {ColorScheme? cs}) {
    if (task.due == null) {
      return MonthContainer(
        name: task.path.name,
        year: 9999,
        month: 12,
        list: [task],
        color: taskColors[task.path.color] ?? (cs!.primary),
        folder: task.path,
      );
    }
    return MonthContainer(
      name: monthColors.keys.elementAt(task.due!.month - 1),
      year: task.due!.year,
      month: task.due!.month,
      list: [task],
      color: monthColors.values.elementAt(task.due!.month - 1),
    );
  }

  int compareTo(MonthContainer other) {
    if (year != other.year) return year.compareTo(other.year);
    return month.compareTo(other.month);
  }

  Map<int, MonthContainer> toMap() => {year * 100 + month: this};
}

class _CalendarState extends State<Calendar> {
  void sortTasks(List<Task> list, int reverse) => list.sort((a, b) {
        int i = 0;
        if (a.due == null && b.due == null) {
        } else if (a.due == null && b.due != null) {
          i = 1;
        } else if (a.due != null && b.due == null) {
          i = -1;
        } else {
          i = a.due!.compareTo(b.due!);
        }
        if (i == 0) return a.name.compareTo(b.name);
        return reverse * i;
      });

  void addTaskToList(
    Task task,
    List<MonthContainer> list, {
    int reverse = 1,
  }) {
    for (var monthContainer in list) {
      if (monthContainer.duringTask(task)) {
        monthContainer.list.add(task);
        sortTasks(monthContainer.list, reverse);
        return;
      }
    }
    list.add(MonthContainer.fromTask(
      task,
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
        color: Theme.of(context).colorScheme.background,
      ));

      for (var folder in structure.values) {
        bool ignored = false;
        for (var str in pf['ignore']) {
          if (folder.name.startsWith(str)) ignored = true;
        }
        if (ignored) continue;
        for (var task in folder.items) {
          if (pf['showPinned'] && task.pinned) {
            list[0][0].list.add(task);
          } else if (!pf['showDone'] && task.done) {
            continue;
          } else if (task.due != null) {
            int comparation = task.due!.compareTo(today());
            if (comparation == 0) {
              list[0][0].list.add(task); //TODAY
            } else {
              addTaskToList(
                task,
                list[{-1: 2, 1: 1}[comparation] ?? 0],
                reverse: comparation,
              );
            }
          } else if (pf['showFolders']) {
            addTaskToList(task, list[3]);
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
                margin: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 32),
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
                        shape: const RoundedRectangleBorder(borderRadius: customRadius),
                        shadowColor: Colors.transparent,
                        color: data[i][j].color.withOpacity(0.3),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            children: [
                              Text(data[i][j].name),
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: data[i][j].list.length,
                                itemBuilder: (context, k) {
                                  Task task = data[i][j].list[k];
                                  return task
                                      .toSetting(
                                        title: task.path.prefix == ''
                                            ? '${task.date()}   ${task.name}'
                                            : '${task.date()}   ${task.path.prefix} ${task.name}',
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

Future pickDate(Task task, BuildContext context) async {
  FocusScope.of(context).unfocus();
  task.due ??= DateTime.now();
  /*
  TimeOfDay tod = TimeOfDay.fromDateTime(task.due!);
  showTimePicker(
          builder: (context, child2) => child2!,
          initialEntryMode: TimePickerEntryMode.dial,
          context: context,
          initialTime: TimeOfDay.fromDateTime(task.due!))
      .then((date) => tod = date!);
	*/
  task.due = await showDatePicker(
    builder: (context, child2) => child2!,
    context: context,
    initialDate: task.due!,
    firstDate: DateTime(DateTime.now().year - 1),
    lastDate: DateTime(DateTime.now().year + 5),
  );
  await task.update();
}

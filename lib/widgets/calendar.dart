import 'package:flutter/material.dart';

import '../data.dart';
import '../functions.dart';
import '../functions/layers.dart';
import '../functions/open_task.dart';
import '../pages/task.dart';
import '../task.dart';

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

  MonthContainer({
    required this.name,
    required this.year,
    required this.color,
    required this.month,
    required this.list,
  });

  bool duringTask(Task task) {
    if (task.due == null) return '/$name' == task.path.name;
    if (task.due!.month != month) return false;
    if (task.due!.year != year) return false;
    return true;
  }

  static MonthContainer fromTask(Task task, {ColorScheme? cs}) {
    if (task.due == null) {
      return MonthContainer(
        name: task.path.name.substring(1),
        year: 9999,
        month: 12,
        list: [task],
        color: cs!.primary,
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
  void addTaskToList(Task task, List<MonthContainer> list, {int reverse = 1}) {
    for (var monthContainer in list) {
      if (monthContainer.duringTask(task)) {
        monthContainer.list.add(task);
        monthContainer.list.sort(
          (a, b) => reverse * (a.due?.compareTo(b.due ?? a.due!) ?? 1),
        );
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
      MonthContainer pinned = MonthContainer(
        name: ' ',
        year: 9999,
        month: 9999,
        list: [],
        color: Theme.of(context).colorScheme.background,
      );
      List<MonthContainer> fromToday = [
        MonthContainer.fromTask(
          Task.defaultNew(
            Folder.defaultNew(),
            name: '----------',
          )..due = DateTime.now(),
        ),
      ];
      List<MonthContainer> toToday = [];
      List<MonthContainer> folders = [];

      DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));

      for (var folder in tasks.values) {
        bool ignored = false;
        for (var str in pf['ignore']) {
          if (folder.name.startsWith(str)) ignored = true;
        }
        if (ignored) continue;
        for (var task in folder.items) {
          if (pf['showPinned'] && task.pinned) {
            pinned.list.add(task);
          } else if (!pf['showDone'] && task.done) {
            continue;
          } else if (task.due != null) {
            if (task.due!.isAfter(yesterday)) {
              addTaskToList(task, fromToday);
            } else {
              addTaskToList(task, toToday, reverse: -1);
            }
          } else if (pf['showFolders'] && !task.path.name.contains('.')) {
            addTaskToList(task, folders);
          }
        }
      }
      return [
        [pinned],
        fromToday,
        toToday,
        folders
      ];
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
                  margin: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  shadowColor: Colors.transparent,
                  color: Theme.of(context).primaryColor.withOpacity(0.08),
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data[i].length,
                    shrinkWrap: true,
                    itemBuilder: (context, j) {
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
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
                                  return ListTile(
                                    onTap: () => showSheet(
                                      func: openTask,
                                      param: task.id,
                                    ),
                                    onLongPress: () => goToPage(
                                      TaskPage(task: task),
                                    ),
                                    title: Text('${task.date()}   ${task.name}'),
                                    trailing: InkWell(
                                      borderRadius: BorderRadius.circular(16),
                                      onTap: () {
                                        task.done = !task.done;
                                        task.update();
                                      },
                                      child: Icon(
                                        task.checked(),
                                        color: taskColors[task.color],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              });
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

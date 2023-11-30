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

Map<String, Color> calendarColors = {
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
  ' ': Colors.transparent,
};

class _CalendarState extends State<Calendar> {
  @override
  Widget build(BuildContext context) {
    calendarColors[' '] = Theme.of(context).colorScheme.background;

    Map<String, List<Task>> fetchAllTasks() {
      Map<String, List<Task>> list = {
        calendarColors.keys.elementAt(DateTime.now().month - 1): [
          Task.defaultNew(
            Folder.defaultNew(),
            name: '-----',
          )..due = DateTime.now(),
        ],
      };
      for (int i = 0; i < tasks.length; i++) {
        List<Task> sublist = tasks.values.elementAt(i).items;
        for (int j = 0; j < sublist.length; j++) {
          Task task = sublist[j];
          String? month;
          if (task.pinned && pf['showPinned']) {
            month = ' ';
          } else if (!pf['showPending'] && task.due == null || !pf['showDone'] && task.done) {
            continue;
          }
          if (!task.path.name.contains('.')) {
            if (month == null && task.due == null) {
              month = task.path.name.substring(1);
            }
            month ??= calendarColors.keys.elementAt(task.due!.month - 1);
            if (list.containsKey(month)) {
              if (!list[month]!.contains(task)) list[month]!.add(task);
            } else {
              list.addAll({
                month: [task]
              });
            }

            list[month]?.sort((b, a) {
              if (!a.hasDue() || !b.hasDue()) return 0;
              return a.due!.compareTo(b.due!);
            });
          }
        }
      }
      Map<String, List<Task>> sorted = Map.fromEntries(list.entries.toList()
        ..sort((e2, e1) {
          List list = calendarColors.keys.toList();
          return list.indexOf(e1.key).compareTo(list.indexOf(e2.key));
        }));
      return sorted;
    }

    return RefreshIndicator(
      onRefresh: sync,
      child: StreamBuilder(
        stream: streamNote.snapshots(),
        builder: (context, data) {
          Map<String, List<Task>> allTasks = fetchAllTasks();
          return ListView.builder(
            physics: scrollPhysics,
            itemCount: allTasks.length,
            padding: const EdgeInsets.only(bottom: 64, top: 8),
            itemBuilder: (context, i) {
              String month = allTasks.keys.elementAt(i);
              return Card(
                margin: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                shadowColor: Colors.transparent,
                color: (calendarColors[month] ??
                        taskColors[tasks['/$month']?.color] ??
                        Theme.of(context).colorScheme.primary)
                    .withOpacity(0.3),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: [
                      Text(month),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: allTasks[month]!.length,
                        itemBuilder: (context, j) {
                          Task task = allTasks[month]![j];
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

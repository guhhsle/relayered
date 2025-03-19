import 'package:flutter/material.dart';
import '../layers/folder_options.dart';
import '../template/functions.dart';
import '../classes/schedule.dart';
import '../classes/database.dart';
import '../classes/month.dart';
import '../layers/folder.dart';
import '../template/data.dart';
import '../layers/task.dart';
import '../functions.dart';
import '../data.dart';
import '../template/prefs.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([Database(), Preferences()]),
      builder: (context, snap) {
        Schedule schedule = Schedule(context: context);
        return ListView.builder(
          itemCount: schedule.list.length,
          physics: scrollPhysics,
          padding: const EdgeInsets.only(bottom: 64),
          itemBuilder: (context, i) {
            List<MonthContainer> fields = schedule.list[i];
            if (fields.isEmpty) return Container();
            return Card(
              margin: const EdgeInsets.only(
                top: 8,
                left: 8,
                right: 8,
                bottom: 32,
              ),
              shape: const RoundedRectangleBorder(borderRadius: customRadius),
              shadowColor: Colors.transparent,
              color: Theme.of(context).primaryColor.withValues(alpha: 0.08),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: fields.length,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemBuilder: (context, j) {
                  MonthContainer field = fields[j];
                  if (field.isEmpty) return Container();
                  return InkWell(
                    borderRadius: customRadius,
                    onTap: FolderLayer(field.folder?.id).show,
                    onLongPress: FolderOptions(field.folder?.id).show,
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 8,
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: customRadius,
                      ),
                      shadowColor: Colors.transparent,
                      color: field.color.withValues(alpha: 0.3),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          children: [
                            Text(t(field.name)),
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemCount: field.list.length,
                              itemBuilder: (context, k) {
                                final entry = field.list[k];
                                String prefix = '';
                                if (entry.value.path.prefix != '') {
                                  prefix = '${entry.value.path.prefix} ';
                                }
                                String? date;
                                date = entry.key?.prettify(false, false);
                                date ??= '  ';
                                date += '  ';
                                String title =
                                    '$date$prefix${entry.value.name}';
                                return entry.value.toTile(() {
                                  TaskLayer(entry.value.id).show();
                                }, title: title).toWidget;
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
    );
  }
}

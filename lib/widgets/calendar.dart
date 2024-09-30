import 'package:flutter/material.dart';
import '../classes/month.dart';
import '../classes/schedule.dart';
import '../classes/database.dart';
import '../data.dart';
import '../functions/task.dart';
import '../template/data.dart';
import '../template/functions.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: Database.sync,
      child: StreamBuilder(
        stream: Database.stream,
        builder: (context, snap) {
          Schedule schedule = Schedule(context: context);
          return ListView.builder(
            itemCount: schedule.list.length,
            physics: scrollPhysics,
            padding: const EdgeInsets.only(bottom: 64),
            itemBuilder: (context, i) {
              List<MonthContainer> fields = schedule.list[i];
              return Card(
                margin: const EdgeInsets.only(
                  top: 8,
                  left: 8,
                  right: 8,
                  bottom: 32,
                ),
                shape: const RoundedRectangleBorder(borderRadius: customRadius),
                shadowColor: Colors.transparent,
                color: Theme.of(context).primaryColor.withOpacity(0.08),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: fields.length,
                  shrinkWrap: true,
                  itemBuilder: (context, j) {
                    MonthContainer field = fields[j];
                    return InkWell(
                      borderRadius: customRadius,
                      onTap: field.folder?.open ?? () {},
                      onLongPress: field.folder?.options ?? () {},
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 8,
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius: customRadius,
                        ),
                        shadowColor: Colors.transparent,
                        color: field.color.withOpacity(0.3),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            children: [
                              Text(t(field.name)),
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: field.list.length,
                                itemBuilder: (context, k) {
                                  final entry = field.list[k];
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
                                  String title =
                                      '$date$prefix${entry.value.name}';
                                  return entry.value
                                      .toTile(title: title)
                                      .toWidget(context);
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

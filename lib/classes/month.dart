import 'package:flutter/material.dart';
import '../data.dart';
import 'folder.dart';
import 'task.dart';

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

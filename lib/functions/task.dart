import '../classes/folder.dart';
import '../classes/task.dart';
import '../data.dart';
import '../template/layer.dart';

String formatDate(
  DateTime? dt, {
  bool year = true,
  bool month = true,
}) {
  if (dt == null) return '';
  String years = year ? '.${dt.year}' : '';
  String months =
      month ? (dt.month < 10 ? '.0${dt.month}' : '.${dt.month}') : '';
  String days = dt.day < 10 ? '0${dt.day}' : '${dt.day}';
  return '$days$months$years';
}

DateTime today() {
  DateTime now = DateTime.now();
  return DateTime(
    now.year,
    now.month,
    now.day,
  );
}

List<Setting> foldersIn(String id) {
  if (structure[id] == null) return [];
  List<Setting> list = [];

  for (String nodeId in structure[id]!.nodes) {
    for (Folder node in structure.values.where((e) => e.id == nodeId)) {
      list.add(node.toSetting);
    }
  }

  return list;
}

List<Setting> tasksIn(String id, bool done) {
  if (structure[id] == null) return [];
  List<Setting> list = [];

  for (Task task in structure[id]!.items) {
    if (task.done == done) {
      list.add(task.toSetting());
    }
  }

  return list;
}

List<Task> pinnedTasks() {
  List<Task> result = [];
  for (Folder folder in structure.values) {
    for (Task task in folder.items) {
      if (task.pinned) result.add(task);
    }
  }
  return result;
}

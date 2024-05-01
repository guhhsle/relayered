import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data.dart';
import '../task.dart';
import '../template/layer.dart';

StreamSubscription<QuerySnapshot<Map<String, dynamic>>> listenNotes() {
  streamNote = coll();
  return streamNote.snapshots().listen((data) {
    structure.clear();

    for (QueryDocumentSnapshot snap in data.docs) {
      Folder folder = Folder.fromJson(snap.data() as Map);
      folder.id = snap.id;
      structure.addAll({snap.id: folder});
      folder.items.sort((a, b) {
        if (a.hasDue && b.hasDue) {
          return a.dues[0].compareTo(b.dues[0]);
        } else if (!a.hasDue && !b.hasDue) {
          return a.name.compareTo(b.name);
        } else if (!a.hasDue) {
          return 1;
        } else {
          return -1;
        }
      });

      refreshLayer();
    }
    for (Folder folder in structure.values) {
      for (int i = 0; i < folder.nodes.length; i++) {
        String node = folder.nodes[i];
        Folder? connection = structure[node];
        if (connection == null) {
          folder.nodes.removeAt(i);
          i--;
        } else if (!connection.nodes.contains(folder.id) && folder.id != null) {
          connection.nodes.add(folder.id!);
        }
      }
      folder.nodes.sort((a, b) {
        return structure[a]!.name.compareTo(structure[b]!.name);
      });
    }
    structure = Map.fromEntries(
      structure.entries.toList()..sort((e1, e2) => e1.value.name.compareTo(e2.value.name)),
    );
  });
}

Future sync() async {
  if (user.isAnonymous) return;
  await FirebaseFirestore.instance.enableNetwork();
  await Future.delayed(Duration(seconds: pf['syncTimeout']));
  await FirebaseFirestore.instance.disableNetwork();
}

String formatDate(
  DateTime? dt, {
  bool year = true,
  bool month = true,
}) {
  if (dt == null) return '';
  String years = year ? '.${dt.year}' : '';
  String months = month ? (dt.month < 10 ? '.0${dt.month}' : '.${dt.month}') : '';
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
      list.add(node.toSetting());
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

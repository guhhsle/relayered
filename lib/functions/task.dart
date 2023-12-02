import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../data.dart';
import '../functions.dart';
import '../task.dart';

StreamSubscription<QuerySnapshot<Map<String, dynamic>>> listenNotes(User us) {
  streamNote = coll();
  return streamNote.snapshots().listen(
    (data) {
      //tasks = {'Pinned': [], '/': []};
      tasks.clear();
      for (var i = 0; i < data.docs.length; i++) {
        Folder folder = Folder.fromJson(data.docs[i].data());
        folder.id = data.docs[i].id;
        if (tasks.containsKey(folder.name)) {
          Folder folder2 = Folder.fromJson(tasks[folder.name]!.toJson());
          folder2.items += folder.items;
          folder.delete();
          folder2.update();
        } else {
          tasks.addAll({folder.name: folder});
        }
      }
      for (Folder folder in tasks.values.toList()) {
        folder.items.sort((a, b) {
          if (a.due == null) return 1;
          if (b.due == null) return -1;
          return a.due!.compareTo(b.due!);
        });
        for (int q = 1; q < folder.name.length; q++) {
          if (folder.name[q] == '/') {
            String name = folder.name.substring(0, q);
            if (!tasks.containsKey(name)) {
              tasks.addAll({name: Folder.defaultNew(name: name)});
            }
          }
        }
      }
      refreshLayer();
    },
  );
}

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
          tasks[folder.name]!.items += folder.items;
        } else {
          tasks.addAll({folder.name: folder});
        }
      }
      for (Folder folder in tasks.values.toList()) {
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

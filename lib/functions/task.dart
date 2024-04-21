import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data.dart';
import '../functions.dart';
import '../task.dart';

StreamSubscription<QuerySnapshot<Map<String, dynamic>>> listenNotes(User us) {
  streamNote = coll();
  return streamNote.snapshots().listen((data) {
    structure.clear();

    for (QueryDocumentSnapshot snap in data.docs) {
      Folder folder = Folder.fromJson(snap.data() as Map);
      folder.id = snap.id;
      structure.addAll({snap.id: folder});
      folder.items.sort((a, b) {
        if (a.due == null) return 1;
        if (b.due == null) return -1;
        return a.due!.compareTo(b.due!);
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

// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../firebase_options.dart';
import '../data.dart';
import '../template/functions.dart';
import '../template/layer.dart';
import 'folder.dart';

class Database {
  static final Database instance = Database.internal();
  static final StreamController structureStream = StreamController.broadcast();

  static Stream get stream => structureStream.stream;

  factory Database() => instance;

  Database.internal();

  static User get user => auth.currentUser!;
  static FirebaseAuth get auth => FirebaseAuth.instance;

  static bool get logged {
    if (user.isAnonymous) return false;
    if (user.email == null) return false;
    return true;
  }

  Future<void> init() async {
    web = kIsWeb;
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseFirestore.instance.settings = const Settings(
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
    if (auth.currentUser == null) await auth.signInAnonymously();
    if (!kIsWeb) await FirebaseFirestore.instance.disableNetwork();
    auth.userChanges().listen((user) {
      if (user != null) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('folders')
            .snapshots()
            .listen((data) {
          refreshStructure(data);
          structureStream.sink.add(data);
        });
      }
      structureStream.sink.add(user);
    });
  }

  static Future<void> signIn(
    String email,
    String password,
    BuildContext context,
  ) async {
    await FirebaseFirestore.instance.enableNetwork();
    try {
      try {
        await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      } catch (e) {
        await auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      }
    } catch (e) {
      showSnack('$e', false);
    }
  }

  static Future<void> resetPassword(String email, BuildContext context) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      showSnack('Request for password reset sent, check your email', false);
    } on FirebaseAuthException catch (e) {
      showSnack(e.code, false);
    }
  }

  static CollectionReference get folders {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('folders');
  }

  void refreshStructure(QuerySnapshot data) {
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
      structure.entries.toList()
        ..sort((e1, e2) {
          return e1.value.name.compareTo(e2.value.name);
        }),
    );
    refreshLayer();
  }

  static Future sync() async {
    if (Database.auth.currentUser!.isAnonymous) return;
    await FirebaseFirestore.instance.enableNetwork();
    await Future.delayed(Duration(seconds: pf['syncTimeout']));
    await FirebaseFirestore.instance.disableNetwork();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'folder.dart';
import '../template/functions.dart';
import '../firebase_options.dart';
import '../data.dart';

class Database extends ChangeNotifier {
  Database.internal();

  static final Database instance = Database.internal();
  factory Database() => instance;
  static StreamController structureStream = StreamController.broadcast();
  static Stream get stream => structureStream.stream;
  static User get user => auth.currentUser!;
  static FirebaseAuth get auth => FirebaseAuth.instance;
  static FirebaseFirestore get firestore => FirebaseFirestore.instance;
  static CollectionReference get folders => userFolders(user.uid);

  static bool get logged {
    if (user.isAnonymous) return false;
    if (user.email == null) return false;
    return true;
  }

  static void notify() => instance.notifyListeners();

  Future<void> init() async {
    web = kIsWeb;
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    firestore.settings = const Settings(
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
    if (auth.currentUser == null) await auth.signInAnonymously();
    if (!kIsWeb) await firestore.disableNetwork();
    auth.userChanges().listen((user) {
      if (user != null) {
        userFolders(user.uid).snapshots().listen((data) {
          refreshStructure(data);
          structureStream.sink.add(data);
        });
      }
      structureStream.sink.add(user);
    });
  }

  static Future<void> signIn(String email, String password) async {
    await firestore.enableNetwork();
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

  static Future<void> resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      showSnack('Request for password reset sent, check your email', false);
    } on FirebaseAuthException catch (e) {
      showSnack(e.code, false);
    }
  }

  static CollectionReference userFolders(String userID) {
    return firestore.collection('users').doc(userID).collection('folders');
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
    notify();
  }

  static Future sync() async {
    if (user.isAnonymous) return;
    await firestore.enableNetwork();
    await Future.delayed(Duration(seconds: Pref.syncTimeout.value));
    await firestore.disableNetwork();
  }
}

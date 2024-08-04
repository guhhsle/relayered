// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../firebase_options.dart';
import '../data.dart';
import '../functions/task.dart';
import '../pages/home.dart';
import '../template/functions.dart';

class Database {
  static final Database instance = Database.internal();
  static final FirebaseAuth auth = FirebaseAuth.instance;

  factory Database() => instance;

  Database.internal() {
    init();
  }

  Future<void> init() async {
    web = kIsWeb;
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseFirestore.instance.settings = const Settings(
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
    if (FirebaseAuth.instance.currentUser == null) {
      await FirebaseAuth.instance.signInAnonymously();
    }
    if (!kIsWeb) await FirebaseFirestore.instance.disableNetwork();
    user = FirebaseAuth.instance.currentUser!;
    noteStream = listenNotes();
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
    user = FirebaseAuth.instance.currentUser!;
    noteStream = listenNotes();

    Navigator.of(context).push(MaterialPageRoute(
      builder: (c) => const HomePage(),
    ));
  }

  static Future<void> resetPassword(String email, BuildContext context) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      showSnack('Request for password reset sent, check your email', false);
    } on FirebaseAuthException catch (e) {
      showSnack(e.code, false);
    }
  }
}

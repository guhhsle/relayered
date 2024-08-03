import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'data.dart';
import 'functions/task.dart';
import 'pages/home.dart';
import 'template/app.dart';
import 'template/prefs.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  web = kIsWeb;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseFirestore.instance.settings = const Settings(
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  await initPrefs();

  if (FirebaseAuth.instance.currentUser == null) {
    await FirebaseAuth.instance.signInAnonymously();
  }
  if (!kIsWeb) await FirebaseFirestore.instance.disableNetwork();
  user = FirebaseAuth.instance.currentUser!;
  noteStream = listenNotes();
  runApp(const App(
    title: 'Relayered',
    child: HomePage(),
  ));
}

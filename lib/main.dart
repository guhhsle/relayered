import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';
import 'data.dart';
import 'functions/task.dart';
import 'pages/homepage.dart';
import 'template/data.dart';
import 'template/prefs.dart';
import 'template/theme.dart';

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
  await FirebaseFirestore.instance.disableNetwork();
  user = FirebaseAuth.instance.currentUser!;
  noteStream = listenNotes();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => const Home();
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: themeNotifier,
      builder: (context, data, widget) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          theme: theme(color(true, lightTheme: true), color(false, lightTheme: true)),
          darkTheme: theme(color(true, lightTheme: false), color(false, lightTheme: false)),
          title: 'Relayered',
          home: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              systemNavigationBarColor: {
                'Black': Colors.black,
                'Primary': color(true),
                'Transparent': color(false),
              }[pf['appbar']],
              systemNavigationBarIconBrightness: Brightness.dark,
            ),
            child: Builder(
              builder: (context) {
                SystemChrome.setSystemUIOverlayStyle(
                  const SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                  ),
                );
                return const HomePage();
              },
            ),
          ),
        );
      },
    );
  }
}

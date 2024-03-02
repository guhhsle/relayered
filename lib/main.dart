import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:relayered/firebase_options.dart';

import 'data.dart';
import 'functions.dart';
import 'functions/task.dart';
import 'pages/homepage.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  web = kIsWeb;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  /*
    options: web
        ? const FirebaseOptions(
            apiKey: "AIzaSyDGpEQYTrJoxD7IKwGRYD3Eu_zGbvZvvWI",
            authDomain: "relayered-39.firebaseapp.com",
            projectId: "relayered-39",
            storageBucket: "relayered-39.appspot.com",
            messagingSenderId: "675281183231",
            appId: "1:675281183231:web:c52713b2e93a705e1f47ca",
            measurementId: "G-E9BWD4GDWF",
          )
        : null,
Platform  Firebase App Id
web       1:675281183231:web:c52713b2e93a705e1f47ca
android   1:675281183231:android:fced4c0d2e302e321f47ca
ios       1:675281183231:ios:d72b704471f68f911f47ca
macos     1:675281183231:ios:3a9cd96471923e261f47ca
	 */

  FirebaseFirestore.instance.settings = const Settings(
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  await initPrefs();
  if (pf['firstBoot']) {
    await FirebaseAuth.instance.signInAnonymously();
  }
  await FirebaseFirestore.instance.disableNetwork();
  user = FirebaseAuth.instance.currentUser!;
  noteStream = listenNotes(user);
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
          theme: theme(color(true), color(false)),
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

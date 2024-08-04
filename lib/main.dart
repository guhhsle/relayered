import 'package:flutter/material.dart';
import 'classes/database.dart';
import 'pages/home.dart';
import 'template/app.dart';
import 'template/prefs.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Database().init();
  await initPrefs();
  runApp(const App(
    title: 'Relayered',
    child: HomePage(),
  ));
}

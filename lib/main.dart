import 'package:flutter/material.dart';
import 'classes/database.dart';
import 'pages/home.dart';
import 'template/app.dart';
import 'template/prefs.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences().init();
  await Database().init();
  runApp(const App(title: 'Relayered', child: HomePage()));
}

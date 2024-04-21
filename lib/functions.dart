import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'data.dart';
import 'theme.dart';

void refreshInterface() {
  themeNotifier.value = theme(color(true), color(false));
}

Color color(bool primary) {
  if (primary) {
    return colors[pf['primary']] ?? Color(int.tryParse('0xFF${pf['primary']}') ?? 0xFF170a1c);
  } else {
    return colors[pf['background']] ?? Color(int.tryParse('0xFF${pf['background']}') ?? 0xFFf6f7eb);
  }
}

Color lighterColor(Color p, Color q) {
  if (p.computeLuminance() > q.computeLuminance()) return p;
  return q;
}

Future sync() async {
  if (user.isAnonymous) return;
  await FirebaseFirestore.instance.enableNetwork();
  await Future.delayed(Duration(seconds: pf['syncTimeout']));
  await FirebaseFirestore.instance.disableNetwork();
}

String formatDate(
  DateTime dt, {
  bool year = true,
  bool month = true,
}) {
  String years = year ? '.${dt.year}' : '';
  String months = month ? (dt.month < 10 ? '.0${dt.month}' : '.${dt.month}') : '';
  String days = dt.day < 10 ? '0${dt.day}' : '${dt.day}';
  return '$days$months$years';
}

DateTime today() {
  DateTime now = DateTime.now();
  return DateTime(
    now.year,
    now.month,
    now.day,
  );
}

void refreshLayer() {
  refreshLay.value = !refreshLay.value;
}

void goToPage(Widget page) {
  if (navigatorKey.currentContext == null) return;
  Navigator.of(navigatorKey.currentContext!).push(
    MaterialPageRoute(builder: (c) => page),
  );
}

Future<int> loadLocale() async {
  final String response = await rootBundle.loadString(
    'assets/translations/${pf['locale']}.json',
  );
  l = await jsonDecode(response);
  return 0;
}

String t(dynamic d) {
  String s = '$d';
  return l[s] ?? s;
}

Future<String> getInput(String? init, {String? hintText}) async {
  if (navigatorKey.currentContext == null) return '';
  Completer<String> completer = Completer();
  TextEditingController controller = TextEditingController(text: init);
  BuildContext context = navigatorKey.currentContext!;
  showModalBottomSheet(
    context: context,
    barrierColor: Colors.black.withOpacity(0.8),
    builder: (c) {
      return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: TextField(
          cursorColor: Colors.white,
          decoration: InputDecoration(
            labelText: hintText,
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            floatingLabelAlignment: FloatingLabelAlignment.center,
            labelStyle: const TextStyle(color: Colors.white),
          ),
          autofocus: true,
          controller: controller,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
          ),
          onSubmitted: (text) {
            Navigator.of(c).pop();
            completer.complete(text);
          },
        ),
      );
    },
  );
  return completer.future;
}

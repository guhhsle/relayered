import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data.dart';
import 'theme.dart';

Future<void> initPrefs() async {
  prefs = await SharedPreferences.getInstance();

  for (var i = 0; i < pf.length; i++) {
    String key = pf.keys.elementAt(i);
    if (pf[key] is String) {
      if (prefs.getString(key) == null) {
        prefs.setString(key, pf[key]);
      } else {
        pf[key] = prefs.getString(key)!;
      }
    } else if (pf[key] is int) {
      if (prefs.getInt(key) == null) {
        prefs.setInt(key, pf[key]);
      } else {
        pf[key] = prefs.getInt(key)!;
      }
    } else if (key == 'firstBoot') {
      if (prefs.getBool('firstBoot') == null) {
        prefs.setBool('firstBoot', false);
      } else {
        pf['firstBoot'] = false;
      }
    } else if (pf[key] is bool) {
      if (prefs.getBool(key) == null) {
        prefs.setBool(key, pf[key]);
      } else {
        pf[key] = prefs.getBool(key)!;
      }
    } else if (pf[key] is List<String>) {
      if (prefs.getStringList(key) == null) {
        prefs.setStringList(key, pf[key]);
      } else {
        pf[key] = prefs.getStringList(key)!;
      }
    }
  }
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
  await FirebaseFirestore.instance.enableNetwork();
  await Future.delayed(Duration(seconds: pf['syncTimeout']));
  await FirebaseFirestore.instance.disableNetwork();
}

String formatDate(
  DateTime dt, {
  bool year = true,
}) {
  String years = year ? '.${dt.year}' : '';
  String months = dt.month < 10 ? '0${dt.month}' : '${dt.month}';
  String days = dt.day < 10 ? '0${dt.day}' : '${dt.day}';
  return '$days.$months$years';
}

void setPref(
  String pString,
  var value, {
  bool refresh = false,
}) {
  pf[pString] = value;
  if (value is int) {
    prefs.setInt(pString, value);
  } else if (value is bool) {
    prefs.setBool(pString, value);
  } else if (value is String) {
    prefs.setString(pString, value);
  } else if (value is List<String>) {
    prefs.setStringList(pString, value);
  }
  if (refresh) refreshAll();
}

void refreshAll() {
  themeNotifier.value = theme(color(true), color(false));
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

void revPref(
  String pref, {
  bool refresh = false,
}) =>
    setPref(
      pref,
      !pf[pref],
      refresh: refresh,
    );

void nextPref(
  String pref,
  List<String> list, {
  bool refresh = false,
}) {
  setPref(
    pref,
    list[(list.indexOf(pf[pref]) + 1) % list.length],
    refresh: refresh,
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
  if (s.startsWith('pf//')) {
    return t(pf[s.replaceAll('pf//', '')]);
  }
  return l[s] ?? s;
}

String folderName(String path) {
  if (path == '/') return '/';
  for (var i = path.length - 1; i > 0; i--) {
    if (path[i] == '/') return path.substring(i + 1);
  }
  return path.substring(1);
}

Future<String> getInput(String? init, {String? hintText}) async {
  if (navigatorKey.currentContext == null) return '';
  Completer<String> completer = Completer();
  TextEditingController controller = TextEditingController(text: init);
  BuildContext context = navigatorKey.currentContext!;
  ColorScheme cs = Theme.of(context).colorScheme;
  showModalBottomSheet(
    context: context,
    builder: (c) {
      return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          padding: const EdgeInsets.all(16),
          color: cs.primary,
          height: 64,
          width: double.infinity,
          child: TextField(
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: cs.background.withOpacity(0.2),
              ),
            ),
            autofocus: true,
            controller: controller,
            style: TextStyle(color: cs.background),
            onSubmitted: (text) {
              Navigator.of(c).pop();
              completer.complete(text);
            },
          ),
        ),
      );
    },
  );
  return completer.future;
}

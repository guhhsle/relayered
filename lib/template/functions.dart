import 'package:flashy_flushbar/flashy_flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:async';
import '../template/data.dart';
import '../data.dart';

void goToPage(Widget page) {
  if (navigatorKey.currentContext == null) return;
  Navigator.of(
    navigatorKey.currentContext!,
  ).push(MaterialPageRoute(builder: (c) => page));
}

void showSnack(
  String text,
  bool good, {
  Function()? onTap,
  int duration = 3,
  bool debug = false,
}) {
  if (debug) debugPrint(text);
  if (debug && !Pref.debug.value) return;
  Color back = good ? Colors.green.shade100 : Colors.red.shade100;
  FlashyFlushbar(
    margin: const EdgeInsets.all(16),
    backgroundColor: back.withValues(alpha: 0.9),
    animationDuration: const Duration(milliseconds: 64),
    message: t(text),
    duration: Duration(seconds: duration),
    isDismissible: true,
    onTap: () {
      onTap?.call();
      FlashyFlushbar.cancel();
    },
    messageStyle: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontFamily: Pref.font.value,
    ),
  ).show();
}

Future<String> getPrefInput(Pref pref) => getInput(pref.value, pref.title);

Future<String> getInput(dynamic init, String? hintText) async {
  final completer = Completer<String>();
  TextEditingController controller = TextEditingController(text: '$init');
  BuildContext context = navigatorKey.currentContext!;
  showModalBottomSheet(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.8),
    builder: (c) {
      return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Semantics(
          label: t(hintText ?? 'Input'),
          child: TextField(
            cursorColor: Colors.white,
            decoration: InputDecoration(
              labelText: t(hintText ?? 'Input'),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              floatingLabelAlignment: FloatingLabelAlignment.center,
              labelStyle: const TextStyle(color: Colors.white),
            ),
            autofocus: true,
            controller: controller,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
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

Future<Map> loadLocale() async {
  try {
    final String response = await rootBundle.loadString(
      'assets/translations/${Pref.locale.value}.json',
    );
    l = await jsonDecode(response);
  } catch (e) {
    debugPrint(e.toString());
    l = {};
  }
  return l;
}

String t(s) => l['$s'] ?? '$s';

IconData checked(bool check) {
  if (check) return Icons.radio_button_checked;
  return Icons.radio_button_unchecked;
}

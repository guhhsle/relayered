import 'dart:async';
import 'dart:convert';
import 'package:flashy_flushbar/flashy_flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data.dart';
import '../template/data.dart';
import 'theme.dart';

void goToPage(Widget page) {
  if (navigatorKey.currentContext == null) return;
  Navigator.of(navigatorKey.currentContext!).push(
    MaterialPageRoute(builder: (c) => page),
  );
}

void showSnack(String text, bool good, {Function()? onTap}) {
  FlashyFlushbar(
    leadingWidget: Icon(
      good ? Icons.check_rounded : Icons.error_outline,
      color: Colors.black,
      size: 24,
    ),
    margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
    backgroundColor: good ? Colors.green.shade100 : Colors.red.shade100,
    animationDuration: const Duration(milliseconds: 64),
    message: text,
    duration: const Duration(seconds: 3),
    isDismissible: true,
    onTap: onTap ?? () {},
    messageStyle: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontFamily: pf['font'],
    ),
  ).show();
}

Future<String> getInput(dynamic init, {String? hintText}) async {
  if (navigatorKey.currentContext == null) return '';
  Completer<String> completer = Completer();
  TextEditingController controller = TextEditingController(text: '$init');
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
            labelText: t(hintText ?? ''),
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

void refreshInterface() {
  themeNotifier.value = theme(color(true), color(false));
}

Future<void> loadLocale() async {
  final String response = await rootBundle.loadString(
    'assets/translations/${pf['locale']}.json',
  );
  l = await jsonDecode(response);
}

String t(dynamic d) {
  String s = '$d';
  return l[s] ?? s;
}

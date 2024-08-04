import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'classes/folder.dart';
import 'settings/account.dart';
import 'settings/interface.dart';
import 'template/layer.dart';
import 'template/locale.dart';
import 'template/theme.dart';

Map pf = {
  //MORE
  'locale': 'en',
  //ACCOUNT
  'syncTimeout': 6,
  'encryptKey': '0000000000000000',
  //INTERFACE
  'action': 'Floating',
  'defaultColor': 'Adaptive',
  'primary': 'Purple',
  'background': 'Ivory',
  'primaryDark': 'Pink',
  'backgroundDark': 'Gruv Dark',
  'appbar': 'Black',
  'font': 'JetBrainsMono',
  'stackLayers': false,
  //CALENDAR
  'showDone': true,
  'showFolders': true,
  'showPinned': true,
  'showCalendar': true,
  'ignore': <String>[],
};

final Map<String, Color?> taskColors = {
  'Adaptive': null,
  'White': Colors.white,
  'Orange': Colors.orange,
  'Red': Colors.red,
  'Purple': Colors.purple,
  'Green': Colors.green,
  'Blue': Colors.blue,
  'Yellow': Colors.yellow,
};

late bool web;

final List<Setting> settings = [
  Setting(
    'Interface',
    Icons.toggle_on,
    '',
    (c) => showSheet(func: interfaceSet),
  ),
  Setting(
    'Account',
    Icons.person_rounded,
    '',
    (c) => showSheet(func: accountSet),
  ),
  Setting(
    'Primary',
    Icons.colorize_rounded,
    '',
    (c) => showSheet(func: themeMap, param: true, scroll: true),
  ),
  Setting(
    'Background',
    Icons.colorize_rounded,
    '',
    (c) => showSheet(func: themeMap, param: false, scroll: true),
  ),
  Setting(
    'More',
    Icons.segment_rounded,
    '',
    (c) => showSheet(func: moreSet),
  ),
];

const customRadius = BorderRadius.only(
  topRight: Radius.circular(32),
  topLeft: Radius.circular(16),
  bottomLeft: Radius.circular(16),
  bottomRight: Radius.circular(16),
);

late CollectionReference<Map<String, dynamic>> streamNote;
late User user;
late StreamSubscription noteStream;
Map<String, Folder> structure = {};

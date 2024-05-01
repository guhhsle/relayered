import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'task.dart';

Map pf = {
  //MORE
  'locale': 'en',
  //ACCOUNT
  'syncTimeout': 6,
  'encryptKey': '0000000000000000',
  //INTERFACE
  'action': 'Floating',
  'defaultColor': 'Adaptive',
  'primary': 'Ultramarine',
  'background': 'Ivory',
  'primaryDark': 'Ultramarine',
  'backgroundDark': 'Ivory',
  'appbar': 'Primary',
  'font': 'JetBrainsMono',
  'stackLayers': false,
  //CALENDAR
  'showDone': true,
  'showFolders': true,
  'showPinned': true,
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

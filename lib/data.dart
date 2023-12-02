import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'task.dart';

Map pf = {
  //APP
  'firstBoot': true,
  //MORE
  'locale': 'en',
  //ACCOUNT
  'syncTimeout': 6,
  'encryptKey': 'd203la9d02f9askc',
  //STORAGE
  'defaultFolder': '/',
  //INTERFACE
  'background': 'Ivory',
  'defaultColor': 'Adaptive',
  'primary': 'Ultramarine',
  'appbar': 'Primary',
  'font': 'JetBrainsMono',
  'stackLayers': false,
  //CALENDAR
  'showDone': true,
  'showFolders': true,
  'showPinned': true,
  'taskNow': true,
  'ignore': <String>[],
};

final Map<String, Color> colors = {
  'White': Colors.white,
  'Ivory': const Color(0xFFf6f7eb),
  //'Beige': const Color(0xFFf5f5dc),
  'Pink': const Color(0xFFFEDBD0),
  'Gruv Light': const Color(0xFFC8A58A),
  'Light Green': const Color(0xFFcbe2d4),
  'PinkRed': const Color(0xFFee7674),
  'BlueGrey': Colors.blueGrey,
  'Dark BlueGrey': Colors.blueGrey.shade900,
  'Dark Green': const Color(0xFF25291C),
  'Purple Grey': const Color(0xFF282a36),
  'Ultramarine': const Color(0xFF01161E),
  'Dark Pink': const Color(0xFF442C2E),
  'Purple': const Color(0xFF170a1c),
  'Gruv Dark': const Color(0xFF0F0A0A),
  'Anchor': const Color(0xFF11150D),
  'Black': Colors.black,
};

final Map<String, IconData> iconsTheme = {
  'White': Icons.ac_unit_rounded,
  'Ivory': Icons.ac_unit_rounded,
  'Pink': Icons.spa_outlined,
  'Gruv Light': Icons.local_cafe_outlined,
  'Light Green': Icons.nature_outlined,
  'PinkRed': Icons.spa_outlined,
  'BlueGrey': Icons.filter_drama_rounded,
  'Dark BlueGrey': Icons.filter_drama_rounded,
  'Dark Green': Icons.nature_outlined,
  'Purple Grey': Icons.light,
  'Ultramarine': Icons.water_rounded,
  'Dark Pink': Icons.spa_outlined,
  'Purple': Icons.star_purple500_rounded,
  'Gruv Dark': Icons.local_cafe_outlined,
  'Anchor': Icons.anchor_outlined,
  'Black': Icons.nights_stay_outlined,
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
Map l = {
  'true': 'Ye',
  'false': 'Nye',
};

late final SharedPreferences prefs;

const ScrollPhysics scrollPhysics = BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
late CollectionReference<Map<String, dynamic>> streamNote;
late User user;
late StreamSubscription noteStream;

class Setting {
  final String title, trailing;
  final IconData icon;
  final Color? iconColor;
  final void Function(BuildContext) onTap;
  final void Function(BuildContext)? secondary;
  final void Function(BuildContext)? onHold;

  const Setting(
    this.title,
    this.icon,
    this.trailing,
    this.onTap, {
    this.secondary,
    this.onHold,
    this.iconColor,
  });
}

final ValueNotifier<ThemeData> themeNotifier = ValueNotifier(ThemeData());
final ValueNotifier<bool> refreshLay = ValueNotifier(true);
final navigatorKey = GlobalKey<NavigatorState>();

Map<String, Folder> tasks = {};

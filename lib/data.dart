import 'package:flutter/material.dart';
import 'layers/settings/interface.dart';
import 'layers/settings/account.dart';
import 'layers/settings/other.dart';
import 'template/prefs.dart';
import 'template/theme.dart';
import 'template/tile.dart';

const locales = [
  ...['Serbian', 'English', 'Spanish', 'German', 'French', 'Italian'],
  ...['Polish', 'Portuguese', 'Russian', 'Slovenian', 'Japanese']
];
const tops = ['Primary', 'Black', 'Transparent'];
const initTaskColors = [
  ...['Adaptive', 'White', 'Orange', 'Red'],
  ...['Purple', 'Green', 'Blue', 'Yellow'],
];
const timeouts = [0, 4, 8, 12, 16, 20];
const actionPos = ['Top', 'Floating'];

enum Pref<T> {
  //TEMPLATE
  font('Font', 'JetBrainsMono', Icons.format_italic_rounded, ui: true),
  locale('Language', 'English', Icons.language_rounded, ui: true, all: locales),
  appbar('Top', 'Black', Icons.gradient_rounded, all: tops, ui: true),
  background('Background', 'F0F8FF', Icons.tonality_rounded, ui: true),
  primary('Primary', '000000', Icons.colorize_rounded, ui: true),
  backgroundDark('Dark background', '0F0A0A', Icons.tonality_rounded, ui: true),
  primaryDark('Dark primary', 'FEDBD0', Icons.colorize_rounded, ui: true),
  debug('Developer', false, Icons.code_rounded),
  //INTERFACE
  encryptKey('Encryption key', '0000000000000000', Icons.key_rounded),
  defaultColor('Default color', 'Adaptive', Icons.colorize_rounded),
  showPinned('Show pinned', true, Icons.push_pin_rounded, ui: true),
  showDone('Show done', true, Icons.done_rounded, ui: true),
  showCalendar('Calendar field', true, Icons.calendar_view_day_rounded,
      ui: true),
  showFolders('Folder field', true, Icons.folder_copy_rounded, ui: true),
  ;

  final T initial;
  final List<T>? all;
  final String? title; //Backend is null
  final IconData? icon;
  final bool ui;

  const Pref(this.title, this.initial, this.icon, {this.all, this.ui = false});

  T get value => Preferences.get(this);

  Future set(T val) => Preferences.set(this, val);

  Future rev() => Preferences.rev(this);

  Future next() => Preferences.next(this);

  void nextByLayer({suffix = ''}) => NextByLayer(this, suffix: suffix).show();

  @override
  String toString() => name;
}

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

List<Tile> get settings {
  return [
    Tile('Interface', Icons.toggle_on, '', InterfaceLayer().show),
    Tile('Account', Icons.person_rounded, '', AccountLayer().show),
    Tile('Primary', Icons.colorize_rounded, '', ThemeLayer(true).show),
    Tile('Background', Icons.tonality_rounded, '', ThemeLayer(false).show),
    Tile('More', Icons.segment_rounded, '', OtherLayer().show),
  ];
}

const customRadius = BorderRadius.only(
  topRight: Radius.circular(32),
  topLeft: Radius.circular(16),
  bottomLeft: Radius.circular(16),
  bottomRight: Radius.circular(16),
);

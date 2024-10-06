import 'package:flutter/material.dart';
import 'layers/settings/interface.dart';
import 'layers/settings/account.dart';
import 'layers/settings/other.dart';
import 'classes/folder.dart';
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

enum Pref {
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
  syncTimeout('Sync timeout', 6, Icons.cloud_sync_rounded, all: timeouts),
  encryptKey('Encryption key', '0000000000000000', Icons.key_rounded),
  action('Action button', 'Floating', Icons.folder_rounded, all: actionPos),
  defaultColor('Default color', 'Adaptive', Icons.colorize_rounded),
  showPinned('Show pinned', true, Icons.push_pin_rounded, ui: true),
  showDone('Show done', true, Icons.done_rounded, ui: true),
  showCalendar('Calendar field', true, Icons.calendar_view_day_rounded,
      ui: true),
  showFolders('Folder field', true, Icons.folder_copy_rounded, ui: true),
  ignore('Ignore folders', <String>[], Icons.folder_copy_rounded, ui: true),
  none('', 0, Icons.abc, backend: true),
  ;

  final dynamic initial;
  final List? all;
  final String title;
  final IconData icon;
  final bool ui, backend; //Changing it leads to UI rebuild

  const Pref(this.title, this.initial, this.icon,
      {this.all, this.ui = false, this.backend = false});

  dynamic get value => Preferences.get(this);

  Future set(dynamic val) => Preferences.set(this, val);

  Future rev() => Preferences.rev(this);

  Future next() => Preferences.next(this);

  void nextByLayer({String suffix = ''}) {
    NextByLayer(this, suffix: suffix).show();
  }

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

Map<String, Folder> structure = {};

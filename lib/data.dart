import 'package:flutter/material.dart';
import 'classes/folder.dart';
import 'settings/account.dart';
import 'settings/interface.dart';
import 'template/layer.dart';
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
  action('Action button', 'Floating', Icons.folder_rounded,
      all: ['Top', 'Floating']),
  stackLayers('Stack layers', false, Icons.layers_rounded),
  defaultColor('Default color', 'Adaptive', Icons.colorize_rounded,
      all: initTaskColors),
  showPinned('Show pinned', true, Icons.push_pin_rounded, ui: true),
  showDone('Show done', true, Icons.done_rounded, ui: true),
  showCalendar('Calendar field', true, Icons.calendar_view_day_rounded,
      ui: true),
  showFolders('Folder field', true, Icons.folder_copy_rounded, ui: true),
  ignore('Ignore folders', <String>[], Icons.folder_copy_rounded, ui: true),
  ;

  final dynamic initial;
  final List? all;
  final String title;
  final IconData icon;
  final bool ui; //Changing it leads to UI rebuild

  const Pref(this.title, this.initial, this.icon, {this.all, this.ui = false});

  dynamic get value => Preferences.get(this);

  Future set(dynamic val) => Preferences.set(this, val);

  Future rev() => Preferences.rev(this);

  Future next() => Preferences.next(this);

  void nextByLayer({String suffix = ''}) =>
      Preferences.nextByLayer(this, suffix: suffix);

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
    Tile('Interface', Icons.toggle_on, '',
        onTap: (c) => showSheet(interfaceSet)),
    Tile('Account', Icons.person_rounded, '',
        onTap: (c) => showSheet(accountSet)),
    Tile('Primary', Icons.colorize_rounded, '',
        onTap: (c) => showScrollSheet(ThemePref.toLayer, {'primary': true})),
    Tile('Background', Icons.tonality_rounded, '',
        onTap: (c) => showScrollSheet(ThemePref.toLayer, {'primary': false})),
    //TODO Tile('More', Icons.segment_rounded, '', onTap: (c) => showSheet(moreSet)),
  ];
}

const customRadius = BorderRadius.only(
  topRight: Radius.circular(32),
  topLeft: Radius.circular(16),
  bottomLeft: Radius.circular(16),
  bottomRight: Radius.circular(16),
);

Map<String, Folder> structure = {};

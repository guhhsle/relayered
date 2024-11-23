import 'package:flutter/material.dart';
import '../../template/functions.dart';
import '../../template/settings.dart';
import '../../template/layer.dart';
import '../../template/tile.dart';
import '../../data.dart';

class CalendarSettings extends Layer {
  @override
  void construct() {
    action = Tile('More', Icons.tune_rounded, '', () {
      Navigator.of(context).pop();
      goToPage(const PageSettings());
    });
    list = [
      Tile.fromPref(Pref.showPinned),
      Tile.fromPref(Pref.showDone),
      Tile.fromPref(Pref.showCalendar),
      Tile.fromPref(Pref.showFolders),
    ];
  }
}

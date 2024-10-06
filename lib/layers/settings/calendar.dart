import 'package:flutter/material.dart';
import '../folder.dart';
import '../../template/functions.dart';
import '../../template/settings.dart';
import '../../classes/database.dart';
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
      Tile('Source folders', Icons.rule_folder_rounded, '', () {
        Navigator.of(context).pop();
        SourceFolders().show();
      }),
    ];
  }
}

class SourceFolders extends Layer {
  @override
  void construct() {
    listenTo(Database());
    action = Tile('Sources', Icons.folder_rounded);
    list = [
      for (var folder in structure.values.toList()
        ..sort(
          (a, b) => a.name.compareTo(b.name),
        ))
        Tile.complex(
          folder.name,
          checked(!Pref.ignore.value.contains(folder.name)),
          '',
          FolderLayer(folder.id).show,
          secondary: () {
            List<String> l = Pref.ignore.value;
            if (l.contains(folder.name)) {
              l.remove(folder.name);
            } else {
              l.add(folder.name);
            }
            Pref.ignore.set(l);
          },
        )
    ];
  }
}

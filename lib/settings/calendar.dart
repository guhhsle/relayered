import 'package:flutter/material.dart';
import '../template/functions.dart';
import '../template/settings.dart';
import '../template/layer.dart';
import '../template/tile.dart';
import '../data.dart';

Layer calendar(Layer l) {
  l.action = Tile('More', Icons.tune_rounded, '', () {
    Navigator.of(l.context).pop();
    goToPage(const PageSettings());
  });
  l.list = [
    Tile.fromPref(Pref.showPinned),
    Tile.fromPref(Pref.showDone),
    Tile.fromPref(Pref.showCalendar),
    Tile.fromPref(Pref.showFolders),
    Tile('Source folders', Icons.rule_folder_rounded, '', () {
      Navigator.of(l.context).pop();
      showScrollSheet(sourceFolders);
    }),
  ];
  return l;
}

Layer sourceFolders(Layer l) {
  l.action = Tile('Sources', Icons.folder_rounded);
  l.list = [
    for (var folder in structure.values.toList()
      ..sort(
        (a, b) => a.name.compareTo(b.name),
      ))
      Tile.complex(
        folder.name,
        checked(!Pref.ignore.value.contains(folder.name)),
        '',
        () => folder.open(context: l.context),
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
  return l;
}

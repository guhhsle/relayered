import 'package:flutter/material.dart';
import '../template/functions.dart';
import '../template/settings.dart';
import '../template/layer.dart';
import '../template/tile.dart';
import '../data.dart';

Layer calendar(Map non) {
  return Layer(
    action: Tile('More', Icons.tune_rounded, '', onTap: (c) {
      Navigator.of(c).pop();
      goToPage(const PageSettings());
    }),
    list: [
      Tile.fromPref(Pref.showPinned),
      Tile.fromPref(Pref.showDone),
      Tile.fromPref(Pref.showCalendar),
      Tile.fromPref(Pref.showFolders),
      Tile('Source folders', Icons.rule_folder_rounded, '', onTap: (c) {
        Navigator.of(c).pop();
        showScrollSheet(sourceFolders);
      }),
    ],
  );
}

Layer sourceFolders(Map non) {
  return Layer(
    action: Tile('Sources', Icons.folder_rounded, ''),
    list: [
      for (var folder in structure.values.toList()
        ..sort(
          (a, b) => a.name.compareTo(b.name),
        ))
        Tile(
          folder.name,
          checked(!Pref.ignore.value.contains(folder.name)),
          '',
          onTap: (c) => folder.open(context: c),
          secondary: (c) {
            List<String> l = Pref.ignore.value;
            if (l.contains(folder.name)) {
              l.remove(folder.name);
            } else {
              l.add(folder.name);
            }
            Pref.ignore.set(l);
          },
        )
    ],
  );
}

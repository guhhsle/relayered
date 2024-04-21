import 'package:flutter/material.dart';
import '../functions/open_folder.dart';
import '../data.dart';
import '../functions.dart';
import '../functions/layers.dart';
import '../functions/prefs.dart';
import '../pages/settings.dart';

Layer calendar() => Layer(
      action: Setting(
        'More',
        Icons.tune_rounded,
        '',
        (c) {
          Navigator.of(c).pop();
          goToPage(const PageSettings());
        },
      ),
      list: [
        Setting(
          'Show pinned',
          Icons.push_pin_rounded,
          '${pf['showPinned']}',
          (c) => revPref('showPinned', refresh: true),
        ),
        Setting(
          'Show done',
          Icons.done_rounded,
          '${pf['showDone']}',
          (c) => revPref('showDone', refresh: true),
        ),
        Setting(
          'Folder field',
          Icons.folder_copy_rounded,
          '${pf['showFolders']}',
          (c) => revPref('showFolders', refresh: true),
        ),
        Setting(
          'Source folders',
          Icons.rule_folder_rounded,
          '',
          (c) => showSheet(
            func: sourceFolders,
            param: 0,
            scroll: true,
            hidePrev: c,
          ),
        ),
      ],
    );

Layer sourceFolders(dynamic none) => Layer(
      action: Setting(
        'Sources',
        Icons.folder_rounded,
        '',
        (c) {},
      ),
      list: [
        for (var folder in structure.values.toList()
          ..sort(
            (a, b) => a.name.compareTo(b.name),
          ))
          Setting(
            folder.name,
            pf['ignore'].contains(folder.name) ? Icons.radio_button_off : Icons.radio_button_on,
            '',
            (c) => showSheet(
              func: openFolder,
              param: folder.id,
              scroll: true,
              hidePrev: c,
            ),
            secondary: (c) {
              List<String> l = pf['ignore'];
              if (l.contains(folder.name)) {
                l.remove(folder.name);
              } else {
                l.add(folder.name);
              }
              setPref('ignore', l, refresh: true);
            },
          )
      ],
    );

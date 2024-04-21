import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data.dart';
import '../functions/layers.dart';
import '../functions/prefs.dart';

Layer interface(dynamic d) => Layer(
      action: Setting(
        'Top',
        Icons.gradient_rounded,
        pf['appbar'],
        (c) => nextPref(
          'appbar',
          ['Primary', 'Black', 'Transparent'],
          refresh: true,
        ),
      ),
      list: [
        Setting(
          'Action button',
          Icons.folder_rounded,
          pf['action'],
          (c) => nextPref(
            'action',
            ['Top', 'Floating'],
            refresh: true,
          ),
        ),
        Setting(
          'Task now',
          Icons.calendar_view_week,
          '${pf['taskNow']}',
          (c) => revPref('taskNow'),
        ),
        Setting(
          'Stack layers',
          Icons.layers_rounded,
          '${pf['stackLayers']}',
          (c) => revPref('stackLayers'),
        ),
        Setting(
          'Default color',
          Icons.colorize_rounded,
          pf['defaultColor'],
          (c) => showSheet(
            param: 0,
            func: (i) => Layer(
              action: Setting(
                pf['defaultColor'],
                Icons.colorize_rounded,
                '',
                (c) {},
              ),
              list: [
                for (MapEntry<String, Color?> e in taskColors.entries)
                  Setting(
                    e.key,
                    Icons.circle,
                    '',
                    (c) => setPref('defaultColor', e.key),
                    iconColor: e.value,
                  )
              ],
            ),
          ),
        ),
      ],
    );

Layer themeMap(dynamic p) {
  p is bool;
  Layer layer = Layer(
      action: Setting(
        pf[p ? 'primary' : 'background'],
        p ? Icons.colorize_rounded : Icons.tonality_rounded,
        '',
        (c) => fetchColor(p),
      ),
      list: []);
  for (int i = 0; i < colors.length; i++) {
    String name = colors.keys.toList()[i];
    layer.list.add(
      Setting(
        name,
        iconsTheme[name]!,
        '',
        (c) => setPref(
          p ? 'primary' : 'background',
          name,
          refresh: true,
        ),
        iconColor: colors.values.elementAt(i),
      ),
    );
  }
  return layer;
}

void fetchColor(bool p) {
  Clipboard.getData(Clipboard.kTextPlain).then((value) {
    if (value == null || value.text == null || int.tryParse('0xFF${value.text!.replaceAll('#', '')}') == null) {
      showSnack('Clipboard HEX', false);
    } else {
      setPref(
        p ? 'primary' : 'background',
        value.text,
        refresh: true,
      );
    }
  });
}

void showSnack(String text, bool good) {
  ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
    SnackBar(
      backgroundColor: good ? Colors.green.shade200 : Colors.red.shade200,
      content: Center(
        child: Text(
          text,
          style: const TextStyle(color: Colors.black),
        ),
      ),
    ),
  );
}

import 'package:flutter/material.dart';
import '../data.dart';
import '../template/layer.dart';
import '../template/prefs.dart';

Future<Layer> interface(dynamic d) async => Layer(
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
            func: (i) async => Layer(
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

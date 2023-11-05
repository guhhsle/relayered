import 'package:flutter/material.dart';
import 'package:relayered/settings/interface.dart';

import '../data.dart';
import '../functions.dart';
import '../functions/layers.dart';

Layer storage() => Layer(
      action: Setting(
        'Default',
        Icons.folder_outlined,
        'pf//defaultFolder',
        (c) async {
          String folder = await getInput(pf['defaultFolder']);
          setPref('defaultFolder', folder);
        },
      ),
      list: [
        Setting(
          'Key',
          Icons.key_rounded,
          'pf//encryptKey',
          (c) async {
            Navigator.of(c).pop();
            await getKey(pf['encryptKey']);
          },
        ),
      ],
    );

Future<void> getKey(String init) async {
  String next = await getInput(init);
  if (next.length == 16) {
    setPref('encryptKey', next);
  } else {
    showSnack('MUST BE 16', false);
    getKey(next);
  }
}

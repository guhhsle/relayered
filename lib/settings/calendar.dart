import 'package:flutter/material.dart';

import '../data.dart';
import '../functions.dart';
import '../functions/layers.dart';
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
          'pf//showPinned',
          (c) => revPref('showPinned', refresh: true),
        ),
        Setting(
          'Show done',
          Icons.done_rounded,
          'pf//showDone',
          (c) => revPref('showDone', refresh: true),
        ),
        Setting(
          'Show pending',
          Icons.timer_rounded,
          'pf//showPending',
          (c) => revPref('showPending', refresh: true),
        ),
      ],
    );

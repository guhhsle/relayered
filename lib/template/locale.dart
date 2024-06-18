import 'package:flutter/material.dart';

import '../data.dart';
import '../log.dart';
import 'layer.dart';
import 'license.dart';
import 'prefs.dart';
import 'single_child.dart';

final Map<String, String> locales = {
  'sr': 'Serbian',
  'en': 'English',
  'es': 'Spanish',
  'de': 'German',
  'fr': 'French',
  'it': 'Italian',
  'pl': 'Polish',
  'pt': 'Portuguese',
  'ru': 'Russian',
  'sl': 'Slovenian',
  'ja': 'Japanese',
};

Future<Layer> moreSet(dynamic non) async => Layer(
      action: Setting(
        'Versions',
        Icons.segment_rounded,
        '',
        (c) => singleChildSheet(
          action: Setting(
            'Versions',
            Icons.timeline_rounded,
            '',
            (c) {},
          ),
          child: Text(versions),
        ),
      ),
      list: [
        Setting(
          'License',
          Icons.format_align_center,
          'GPL3',
          (c) => singleChildSheet(
            action: Setting(
              'GPL3',
              Icons.format_align_center_rounded,
              '',
              (c) {},
            ),
            child: Text(license),
          ),
        ),
        Setting(
          'Language',
          Icons.language_rounded,
          locales[pf['locale']]!,
          (c) => showSheet(
            scroll: true,
            hidePrev: c,
            func: (non) async => Layer(
              action: Setting(
                'Language',
                Icons.language_rounded,
                '',
                (c) {},
              ),
              list: [
                ...locales.entries.map((e) => Setting(
                      e.value,
                      Icons.language_rounded,
                      '',
                      (c) => setPref('locale', e.key, refresh: true),
                    ))
              ],
            ),
          ),
        ),
      ],
    );

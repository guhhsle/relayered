import 'package:flutter/material.dart';
import 'dart:async';
import 'template/layer.dart';
import 'template/tile.dart';
import 'data.dart';

Future<String> getCustomColor(String initial) {
  final completer = Completer<String>();
  showScrollSheet(
    (Layer l) {
      l.action = Tile(initial, Icons.colorize_rounded);
      l.list = taskColors.entries.map((col) {
        return Tile.complex(
          '',
          Icons.circle,
          col.key,
          () => completer.complete(col.key),
          iconColor: col.value,
        );
      });
    },
  );
  return completer.future;
}

import 'package:flutter/material.dart';
import 'dart:async';
import 'template/layer.dart';
import 'template/tile.dart';
import 'data.dart';

Future<String> getCustomColor(String initial) {
  final completer = Completer<String>();
  showScrollSheet(
    (Map non) => Layer(
      action: Tile(initial, Icons.colorize_rounded, ''),
      list: taskColors.entries.map((col) {
        return Tile(
          '',
          Icons.circle,
          col.key,
          iconColor: col.value,
          onTap: (c) => completer.complete(col.key),
        );
      }),
    ),
  );
  return completer.future;
}

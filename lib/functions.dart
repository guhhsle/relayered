import 'package:flutter/material.dart';
import 'template/layer.dart';
import 'template/tile.dart';
import 'data.dart';

class ColorLayer extends Layer {
  String initial;
  final void Function(String) onSelected;
  ColorLayer(this.initial, {required this.onSelected});

  @override
  void construct() {
    action = Tile(initial, Icons.colorize_rounded);
    list = taskColors.entries.map((col) {
      return Tile.complex(
        '',
        Icons.circle,
        col.key,
        () => onSelected(col.key),
        iconColor: col.value,
      );
    });
  }
}

extension Prettify on DateTime {
  String prettify([bool showYear = true, bool showMonth = true]) {
    String years = showYear ? '.$year' : '';
    String months = showMonth ? (month < 10 ? '.0$month' : '.$month') : '';
    String days = day < 10 ? '0$day' : '$day';
    return '$days$months$years';
  }
}

DateTime today() {
  DateTime now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

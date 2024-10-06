import 'package:flutter/material.dart';
import 'visual_layer.dart';
import 'prefs.dart';
import 'data.dart';
import 'tile.dart';

abstract class Layer extends ChangeNotifier {
  Iterable<Widget> leading = [], trailing = [];
  BuildContext? dirtyContext;
  Iterable<Tile> list = [];
  Tile action = Tile();
  bool scroll = false;
  List<Listenable> listened = [];

  void listenTo(Listenable listenable) {
    if (listened.contains(listenable)) return;
    listened.add(listenable);
  }

  BuildContext get context {
    if (dirtyContext?.mounted ?? false) return dirtyContext!;
    return navigatorKey.currentContext!;
  }

  void construct();

  Layer show() {
    listenTo(Preferences());
    construct();
    showModalBottomSheet(
      barrierLabel: 'Barrier',
      context: navigatorKey.currentContext!,
      isScrollControlled: true,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (c) => VisualLayer(layer: this),
    );
    return this;
  }
}

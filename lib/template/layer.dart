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
  List<Listenable> listened = [];

  void listenTo(Listenable listenable) {
    if (listened.contains(listenable)) return;
    listened.add(listenable);
  }

  void construct();

  BuildContext get context {
    if (dirtyContext?.mounted ?? false) return dirtyContext!;
    return navigatorKey.currentContext!;
  }

  void layerChange() {
    construct();
    notifyListeners();
  }

  void disposeListeners() {
    for (var listenable in listened) {
      listenable.removeListener(layerChange);
    }
  }

  void initListeners() {
    construct();
    listenTo(Preferences());
    for (var listenable in listened) {
      listenable.addListener(layerChange);
    }
  }

  void show() {
    initListeners();
    showModalBottomSheet(
      barrierLabel: 'Barrier',
      context: navigatorKey.currentContext!,
      isScrollControlled: true,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (c) => VisualLayer(layer: this),
    );
  }
}

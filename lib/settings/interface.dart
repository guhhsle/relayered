import '../template/layer.dart';
import '../template/tile.dart';
import '../data.dart';

Layer interfaceSet(Layer l) {
  l.action = Tile.fromPref(Pref.appbar);
  l.list = [
    Tile.fromPref(Pref.action),
    Tile.fromPref(Pref.stackLayers),
    Tile.fromPref(Pref.defaultColor),
  ];
  return l;
}

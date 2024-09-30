import '../template/layer.dart';
import '../template/tile.dart';
import '../data.dart';

Layer interfaceSet(dynamic d) {
  return Layer(
    action: Tile.fromPref(Pref.appbar),
    list: [
      Tile.fromPref(Pref.action),
      Tile.fromPref(Pref.stackLayers),
      Tile.fromPref(Pref.defaultColor),
    ],
  );
}

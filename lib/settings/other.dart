import '../data.dart';
import '../template/layer.dart';
import '../template/tile.dart';

Layer otherSet(Layer l) {
  l.action = Tile.fromPref(Pref.locale);
  return l;
}

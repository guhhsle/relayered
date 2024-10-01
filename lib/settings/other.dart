import '../data.dart';
import '../template/layer.dart';
import '../template/tile.dart';

Layer otherSet(Map non) {
  return Layer(
    action: Tile.fromPref(Pref.locale),
    list: [],
  );
}

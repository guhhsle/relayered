import '../data.dart';
import '../template/layer.dart';
import '../template/tile.dart';

class OtherLayer extends Layer {
  @override
  void construct() {
    action = Tile.fromPref(Pref.locale);
  }
}

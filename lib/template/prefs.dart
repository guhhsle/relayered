import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'functions.dart';
import 'layer.dart';
import '../data.dart';
import 'theme.dart';
import 'tile.dart';

class Preferences extends ChangeNotifier {
  static final Preferences instance = Preferences.internal();
  static late SharedPreferences prefs;

  factory Preferences() => instance;

  Preferences.internal();

  static void notify() => instance.notifyListeners();

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future rev(Pref pref) => set(pref, !pref.value);

  static Future next(Pref pref) {
    int index = pref.all!.indexOf(pref.value);
    return set(pref, pref.all![(index + 1) % pref.all!.length]);
  }

  static dynamic get(Pref pref) {
    var val = prefs.get('$pref');
    if (val is List) return prefs.getStringList('$pref');
    return val ?? pref.initial;
  }

  static Future set(Pref pref, var value) async {
    if (pref.initial is int) {
      await prefs.setInt('$pref', value);
    } else if (pref.initial is bool) {
      await prefs.setBool('$pref', value);
    } else if (pref.initial is String) {
      await prefs.setString('$pref', value);
    } else if (pref.initial is List<String>) {
      await prefs.setStringList('$pref', value);
    }
    if (pref.ui) ThemePref.notify();
    if (pref.title != null || pref.ui) notify();
    return value;
  }
}

class NextByLayer extends Layer {
  Pref pref;
  String suffix;
  NextByLayer(this.pref, {this.suffix = ''});
  @override
  construct() {
    action = Tile(
      pref.title,
      Icons.memory_rounded,
      '${pref.value}$suffix',
    );
    list = pref.all!.map((e) {
      return Tile('$e$suffix', checked(e == pref.value), '', () {
        pref.set(e);
      });
    });
  }
}

class PrefAsList extends Layer {
  Pref<List<String>> pref;
  PrefAsList(this.pref);
  @override
  construct() {
    action = Tile(pref.title, Icons.list_rounded);
    trailing = [
      IconButton(
        icon: const Icon(Icons.restart_alt_rounded),
        onPressed: () => pref.set(pref.initial),
      ),
      IconButton(
        icon: const Icon(Icons.add_rounded),
        onPressed: () => getInput('', 'Add').then((val) {
          if (pref.value.contains(val)) return;
          pref.set(pref.value.toList()..add(val));
        }),
      ),
    ];
    list = pref.value.map((e) {
      return Tile(e, Icons.highlight_off_rounded, '', () {
        pref.set(pref.value.toList()..remove(e));
      });
    });
  }
}

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'functions.dart';
import 'layer.dart';
import '../data.dart';
import 'theme.dart';
import 'tile.dart';

class Preferences extends ChangeNotifier {
  static final Preferences instance = Preferences.internal();
  static late final SharedPreferences prefs;

  factory Preferences() => instance;

  Preferences.internal();

  static void notify() => instance.notifyListeners();

  Future init() => SharedPreferences.getInstance();

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
    if (value is int) {
      await prefs.setInt('$pref', value);
    } else if (value is bool) {
      await prefs.setBool('$pref', value);
    } else if (value is String) {
      await prefs.setString('$pref', value);
    } else if (value is List<String>) {
      await prefs.setStringList('$pref', value);
    }
    if (pref.ui) ThemePref.notify();
    notify();
    return value;
  }

  static void nextByLayer(Pref pref, {String suffix = ''}) {
    Layer layerFunc(Map map) {
      return Layer(
        action: Tile(pref.title, Icons.memory_rounded, '${pref.value}$suffix'),
        list: pref.all!.map((e) {
          return Tile('$e$suffix', checked(e == pref.value), '', onTap: (c) {
            pref.set(e);
          });
        }).toList(),
      );
    }

    if (pref.all!.length > 5) {
      showScrollSheet(layerFunc);
    } else {
      showSheet(layerFunc);
    }
  }
}

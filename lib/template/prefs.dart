import 'package:shared_preferences/shared_preferences.dart';
import 'functions.dart';
import '../data.dart';
import 'layer.dart';
import 'data.dart';

Future<void> initPrefs() async {
  prefs = await SharedPreferences.getInstance();
  for (MapEntry entry in pf.entries) {
    final val = getPref(entry.key);
    if (val != null) pf[entry.key] = val;
  }
}

void revPref(String pref, {bool refresh = false}) {
  setPref(pref, !pf[pref], refresh: refresh);
}

void nextPref(
  String pref,
  List<String> list, {
  bool refresh = false,
}) {
  setPref(
    pref,
    list[(list.indexOf(pf[pref]) + 1) % list.length],
    refresh: refresh,
  );
}

dynamic getPref(name) {
  var val = prefs.get(name);
  if (val is List) return prefs.getStringList(name);
  return val;
}

dynamic setPref(
  String name,
  var value, {
  bool refresh = false,
}) {
  pf[name] = value;
  if (value is int) {
    prefs.setInt(name, value);
  } else if (value is bool) {
    prefs.setBool(name, value);
  } else if (value is String) {
    prefs.setString(name, value);
  } else if (value is List<String>) {
    prefs.setStringList(name, pf[name]);
  }
  if (refresh) refreshInterface();
  refreshLayer();
  return value;
}

import 'package:shared_preferences/shared_preferences.dart';
import '../data.dart';
import 'data.dart';
import 'functions.dart';
import 'layer.dart';

Future<void> initPrefs() async {
  prefs = await SharedPreferences.getInstance();
  for (MapEntry entry in pf.entries) {
    final val = getPref(entry.key);
    if (val != null) pf[entry.key] = val;
  }
}

Future<void> revPref(String pref, {bool refresh = false}) async {
  await setPref(pref, !pf[pref], refresh: refresh);
}

Future<void> nextPref(String pref, List<String> list, {bool refresh = false}) async {
  await setPref(pref, list[(list.indexOf(pf[pref]) + 1) % list.length], refresh: refresh);
}

dynamic getPref(name) {
  var val = prefs.get(name);
  if (val is List) return prefs.getStringList(name);
  return val;
}

Future setPref(String name, var value, {bool refresh = false}) async {
  pf[name] = value;
  if (value is int) {
    await prefs.setInt(name, value);
  } else if (value is bool) {
    await prefs.setBool(name, value);
  } else if (value is String) {
    await prefs.setString(name, value);
  } else if (value is List<String>) {
    await prefs.setStringList(name, pf[name]);
  }
  if (refresh) refreshInterface();
  refreshLayer();
  return value;
}

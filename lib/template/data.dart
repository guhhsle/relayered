import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Map<String, IconData> colorMap = {
  'FFFFFF': Icons.ac_unit_rounded,
  'F6F7EB': Icons.ac_unit_rounded,
  'F0F8FF': Icons.water_rounded,
  'FEDBD0': Icons.spa_outlined,
  'C8A58A': Icons.local_cafe_rounded,
  'CBE2D4': Icons.nature_outlined,
  'EE7674': Icons.spa_outlined,
  '6A89A7': Icons.filter_drama_rounded,
  '263238': Icons.filter_drama_rounded,
  '25291C': Icons.nature_outlined,
  '282A36': Icons.light,
  '01161E': Icons.tsunami_rounded,
  '442C2E': Icons.spa_outlined,
  '170A1C': Icons.star_purple500_rounded,
  '0F0A0A': Icons.local_cafe_rounded,
  '11150D': Icons.anchor_outlined,
  '000000': Icons.nights_stay_outlined,
};

late final SharedPreferences prefs;
const ScrollPhysics scrollPhysics = BouncingScrollPhysics(
  parent: AlwaysScrollableScrollPhysics(),
);

Map l = {};
final navigatorKey = GlobalKey<NavigatorState>();
final ValueNotifier<ThemeData> themeNotifier = ValueNotifier(ThemeData());
final ValueNotifier<bool> refreshLay = ValueNotifier(true);

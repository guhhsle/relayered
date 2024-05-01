import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Map<String, Color> colors = {
  'White': Colors.white,
  'Ivory': Color(0xFFf6f7eb),
  //'Beige': const Color(0xFFf5f5dc),
  'Pink': Color(0xFFFEDBD0),
  'Gruv Light': Color(0xFFC8A58A),
  'Light Green': Color(0xFFcbe2d4),
  'PinkRed': Color(0xFFee7674),
  'BlueGrey': Colors.blueGrey,
  'Dark BlueGrey': Color(0xFF263238),
  'Dark Green': Color(0xFF25291C),
  'Purple Grey': Color(0xFF282a36),
  'Ultramarine': Color(0xFF01161E),
  'Dark Pink': Color(0xFF442C2E),
  'Purple': Color(0xFF170a1c),
  'Gruv Dark': Color(0xFF0F0A0A),
  'Anchor': Color(0xFF11150D),
  'Black': Colors.black,
};

const Map<String, IconData> iconsTheme = {
  'White': Icons.ac_unit_rounded,
  'Ivory': Icons.ac_unit_rounded,
  'Pink': Icons.spa_outlined,
  'Gruv Light': Icons.local_cafe_outlined,
  'Light Green': Icons.nature_outlined,
  'PinkRed': Icons.spa_outlined,
  'BlueGrey': Icons.filter_drama_rounded,
  'Dark BlueGrey': Icons.filter_drama_rounded,
  'Dark Green': Icons.nature_outlined,
  'Purple Grey': Icons.light,
  'Ultramarine': Icons.water_rounded,
  'Dark Pink': Icons.spa_outlined,
  'Purple': Icons.star_purple500_rounded,
  'Gruv Dark': Icons.local_cafe_outlined,
  'Anchor': Icons.anchor_outlined,
  'Black': Icons.nights_stay_outlined,
};

late final SharedPreferences prefs;
const ScrollPhysics scrollPhysics = BouncingScrollPhysics(
  parent: AlwaysScrollableScrollPhysics(),
);

Map l = {};
final navigatorKey = GlobalKey<NavigatorState>();
final ValueNotifier<ThemeData> themeNotifier = ValueNotifier(ThemeData());
final ValueNotifier<bool> refreshLay = ValueNotifier(true);

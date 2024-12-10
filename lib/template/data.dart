import 'package:flutter/material.dart';

const colorMap = {
  'FFFFFF': Icons.ac_unit_rounded,
  'F6F7EB': Icons.egg_rounded,
  'F0F8FF': Icons.water_rounded,
  'E1C0F0': Icons.bubble_chart_rounded,
  'FEDBD0': Icons.spa_outlined,
  'C8A58A': Icons.local_cafe_rounded,
  'CBE2D4': Icons.nature_outlined,
  'EE7674': Icons.warning_rounded,
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

const scrollPhysics = BouncingScrollPhysics(
  parent: AlwaysScrollableScrollPhysics(),
);

Map l = {};
final navigatorKey = GlobalKey<NavigatorState>();

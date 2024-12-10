import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
import 'functions.dart';
import 'layer.dart';
import 'dart:math';
import 'data.dart';
import 'tile.dart';
import '../data.dart';

class ThemeLayer extends Layer {
  bool primary;
  ThemeLayer(this.primary);
  @override
  construct() {
    action = Tile(
      ThemePref.themePref(primary, currentlyLight).value,
      primary ? Icons.colorize_rounded : Icons.tonality_rounded,
      '',
      () => ThemePref.fetchColor(primary),
    );
    trailing = [
      IconButton(
        icon: const Icon(Icons.shuffle_rounded),
        onPressed: () {
          final hex = ThemePref.randomColor(primary);
          ThemePref.themePref(primary, currentlyLight).set(hex);
        },
      ),
      IconButton(
        icon: const Icon(Icons.add_rounded),
        onPressed: () => ThemePref.fetchColor(primary),
      ),
    ];
    list = colorMap.entries.map((color) {
      return Tile.complex(
        color.key,
        color.value,
        '',
        () => ThemePref.themePref(primary, currentlyLight).set(color.key),
        iconColor: ThemePref.colorFromHex(color.key),
      );
    });
  }
}

bool get currentlyLight {
  var dispatcher = SchedulerBinding.instance.platformDispatcher;
  return dispatcher.platformBrightness == Brightness.light;
}

class ThemePref extends ChangeNotifier {
  static final ThemePref instance = ThemePref.internal();

  factory ThemePref() => instance;

  ThemePref.internal();

  static void notify() => instance.notifyListeners();

  static Color color(bool primary, {bool? light}) {
    try {
      return colorFromHex(themePref(primary, light ?? currentlyLight).value);
    } catch (e) {
      return primary ? Colors.black : Colors.white;
    }
  }

  static Color lighterColor(Color p, Color q) {
    if (p.computeLuminance() > q.computeLuminance()) return p;
    return q;
  }

  static Pref themePref(bool primary, bool light) {
    return {
      (false, false): Pref.backgroundDark,
      (false, true): Pref.background,
      (true, false): Pref.primaryDark,
      (true, true): Pref.primary,
    }[(primary, light)]!;
  }

  static Color colorFromHex(String hex) => Color(int.parse('0xFF$hex'));

  static String randomColor(bool primary, {int? offset}) {
    offset ??= currentlyLight != primary ? 11 : 0;
    String result = '';
    for (int i = 0; i < 6; i++) {
      int random = Random().nextInt(5);
      if (i % 2 == 0) random += offset;
      if (random < 10) {
        result += '$random';
      } else {
        result += String.fromCharCode(random + 55);
      }
    }
    return result;
  }

  static Future<void> fetchColor(bool primary) async {
    try {
      String val = await getInput('', 'HEX value');
      val = val.replaceAll('#', '');
      int.parse('0xFF$val');
      themePref(primary, currentlyLight).set(val);
    } catch (e) {
      showSnack('$e', false);
    }
  }

  static ThemeData data(Color p, Color b) {
    return ThemeData(
      useMaterial3: false,
      colorScheme: ColorScheme(
        primary: p,
        secondary: p,
        brightness: Brightness.light,
        error: Colors.red,
        onError: b,
        onPrimary: b,
        onSecondary: b,
        onSurface: p,
        surface: b,
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStatePropertyAll(p.withOpacity(0.7)),
        radius: const Radius.circular(16),
        thumbVisibility: const WidgetStatePropertyAll(true),
        trackVisibility: const WidgetStatePropertyAll(false),
      ),
      primaryColor: p,
      fontFamily: Pref.font.value,
      scaffoldBackgroundColor:
          {'Black': Colors.black, 'Transparent': b}[Pref.appbar.value] ?? p,
      appBarTheme: AppBarTheme(
        backgroundColor:
            {'Black': Colors.black, 'Transparent': b}[Pref.appbar.value] ?? p,
        foregroundColor: {
              'Black': lighterColor(p, b),
              'Transparent': p
            }[Pref.appbar.value] ??
            b,
        shadowColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: {
                'Black': lighterColor(p, b),
                'Transparent': p
              }[Pref.appbar.value] ??
              b,
          fontFamily: Pref.font.value,
          fontSize: 18,
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: {
              'Black': lighterColor(p, b),
              'Transparent': p
            }[Pref.appbar.value] ??
            b,
      ),
      textTheme: TextTheme(
        titleMedium: TextStyle(fontWeight: FontWeight.w600, color: p),
        titleLarge: TextStyle(fontWeight: FontWeight.w600, color: p),
        titleSmall: TextStyle(fontWeight: FontWeight.w600, color: p),
        bodyMedium: TextStyle(fontWeight: FontWeight.w600, color: p),
        bodyLarge: TextStyle(fontWeight: FontWeight.w600, color: p),
        displayLarge: TextStyle(fontWeight: FontWeight.w600, color: p),
        displayMedium: TextStyle(fontWeight: FontWeight.w600, color: p),
        displaySmall: TextStyle(fontWeight: FontWeight.w600, color: p),
      ),
      inputDecorationTheme: InputDecorationTheme(
        suffixIconColor: p,
        counterStyle: TextStyle(color: p, fontWeight: FontWeight.w600),
        labelStyle: TextStyle(color: p, fontWeight: FontWeight.w600),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: p, width: 2),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: p, width: 2),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        refreshBackgroundColor: b,
      ),
      dialogBackgroundColor: b,
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: p,
        contentTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontFamily: 'JetBrainsMono',
          color: b,
        ),
      ),
      sliderTheme: const SliderThemeData(
        trackHeight: 3,
        thumbShape: RoundSliderThumbShape(
          enabledThumbRadius: 9,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: b,
        selectedColor: p,
        checkmarkColor: b,
        shadowColor: Colors.transparent,
        labelStyle: TextStyle(
          color: p,
          fontWeight: FontWeight.w600,
          fontFamily: Pref.font.value,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: p, width: 2),
        ),
      ),
      listTileTheme: ListTileThemeData(
        textColor: p,
        iconColor: p,
        style: ListTileStyle.drawer,
      ),
      iconTheme: IconThemeData(color: p),
      cardTheme: CardTheme(
        elevation: 6,
        shadowColor: p,
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        color: p,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: p, width: 2),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

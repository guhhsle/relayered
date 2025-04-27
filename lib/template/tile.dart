import 'package:flutter/material.dart';
import 'functions.dart';
import 'prefs.dart';
import '../data.dart';

class Tile {
  void Function()? secondary;
  void Function()? onHold;
  void Function()? onTap;
  dynamic title, trailing;
  Color? iconColor;
  IconData icon = Icons.moped_rounded;

  Tile([
    this.title = '',
    this.icon = Icons.moped_rounded,
    this.trailing = '',
    this.onTap,
  ]);

  Tile.complex(
    this.title,
    this.icon,
    this.trailing,
    this.onTap, {
    this.secondary,
    this.onHold,
    this.iconColor,
  });

  Widget get toWidget {
    Widget? lead, trail;
    if (secondary == null) {
      lead = Icon(icon, color: iconColor);
      trail = Text(t(trailing));
    } else {
      trail = InkWell(
        borderRadius: BorderRadius.circular(10),
        child: Icon(icon, color: iconColor),
        onTap: () => secondary?.call(),
      );
    }

    return Semantics(
      label: t(trailing),
      child: ListTile(
        leading: lead,
        title: Text(t(title)),
        trailing: trail,
        onTap: onTap,
        onLongPress: onHold,
      ),
    );
  }

  static Tile fromPref(
    Pref pref, {
    void Function(String)? onPrefInput,
    void Function()? onTap,
    String suffix = '',
    String prefix = '',
  }) {
    if (onPrefInput != null) {
      onTap = () => getPrefInput(pref).then((i) => onPrefInput.call(i));
    } else if (onTap == null) {
      if (pref.all != null) {
        onTap = () => pref.nextByLayer();
      } else if (pref.initial is bool) {
        onTap = () => pref.rev();
      }
      onTap ??= () {};
    }
    prefix = t(prefix);
    suffix = t(suffix);
    return Tile.complex(
      pref.title,
      pref.icon ?? Icons.moped_rounded,
      '$prefix${t(pref.value)}$suffix',
      onTap,
      onHold: () => pref.set(pref.initial),
    );
  }

  static Tile fromListPref(Pref<List<String>> pref) {
    return Tile(pref.title, pref.icon ?? Icons.moped_rounded, '', () {
      PrefAsList(pref).show();
    });
  }

  Widget get toIconButton {
    return IconButton(
      icon: Icon(icon),
      tooltip: title,
      onPressed: onTap,
    );
  }
}

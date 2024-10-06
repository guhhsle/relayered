import 'package:flutter/material.dart';
import 'data.dart';
import 'functions.dart';
import '../data.dart';

class Tile {
  void Function()? secondary;
  void Function()? onHold;
  void Function()? onTap;
  dynamic title, trailing;
  Color? iconColor;
  IconData icon;
  BuildContext dirtyContext = navigatorKey.currentContext!;

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

  BuildContext get context {
    if (dirtyContext.mounted) {
      return dirtyContext;
    } else {
      return navigatorKey.currentContext!;
    }
  }

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
    return Tile(
      pref.title,
      pref.icon,
      '$prefix${t(pref.value)}$suffix',
      onTap,
    );
  }
}

import 'package:flutter/material.dart';
import '../data.dart';
import 'functions.dart';

class Tile {
  void Function(BuildContext)? secondary;
  void Function(BuildContext)? onHold;
  void Function(BuildContext)? onTap;
  dynamic title, trailing;
  Color? iconColor;
  IconData icon;

  Tile(
    this.title,
    this.icon,
    this.trailing, {
    this.onTap,
    this.secondary,
    this.onHold,
    this.iconColor,
  });

  Widget toWidget(BuildContext context) {
    Widget? lead, trail;
    if (secondary == null) {
      lead = Icon(icon, color: iconColor);
      trail = Text(t(trailing));
    } else {
      trail = InkWell(
        borderRadius: BorderRadius.circular(10),
        child: Icon(icon, color: iconColor),
        onTap: () {
          secondary!(context);
        },
      );
    }

    return Semantics(
      label: t(trailing),
      child: ListTile(
        leading: lead,
        title: Text(t(title)),
        trailing: trail,
        onTap: () => onTap?.call(context),
        onLongPress: () => onHold?.call(context),
      ),
    );
  }

  static Tile fromPref(
    Pref pref, {
    void Function(String)? onPrefInput,
    void Function(BuildContext)? onTap,
    String suffix = '',
    String prefix = '',
  }) {
    if (onPrefInput != null) {
      onTap = (c) => getPrefInput(pref).then((i) => onPrefInput.call(i));
    } else if (onTap == null) {
      if (pref.all != null) {
        onTap = (c) => pref.nextByLayer();
      } else if (pref.initial is bool) {
        onTap = (c) => pref.rev();
      }
      onTap ??= (c) {};
    }
    prefix = t(prefix);
    suffix = t(suffix);
    return Tile(
      pref.title,
      pref.icon,
      '$prefix${t(pref.value)}$suffix',
      onTap: onTap,
    );
  }
}

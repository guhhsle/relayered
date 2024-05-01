import 'package:flutter/material.dart';
import 'data.dart';
import 'functions.dart';
import 'sheet_model.dart';
import 'sheet_scroll.dart';

class Setting {
  String title, trailing;
  IconData icon;
  Color? iconColor;
  void Function(BuildContext) onTap;
  void Function(BuildContext)? secondary;
  void Function(BuildContext)? onHold;

  Setting(
    this.title,
    this.icon,
    this.trailing,
    this.onTap, {
    this.secondary,
    this.onHold,
    this.iconColor,
  });

  ListTile toTile(BuildContext context) {
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
          refreshLayer();
        },
      );
    }

    return ListTile(
      leading: lead,
      title: Text(t(title)),
      trailing: trail,
      onTap: () {
        onTap(context);
        refreshLayer();
      },
      onLongPress: onHold == null
          ? null
          : () {
              onHold!(context);
              refreshLayer();
            },
    );
  }
}

class Layer {
  final Setting action;
  final List<Setting> list;
  List<Widget> Function(BuildContext)? leading, trailing;

  Layer({
    required this.action,
    required this.list,
    this.leading,
    this.trailing,
  });
}

void showSheet({
  required Future<Layer> Function(dynamic) func,
  dynamic param,
  bool scroll = false,
  BuildContext? hidePrev,
}) {
  if (hidePrev != null) Navigator.of(hidePrev).pop();
  showModalBottomSheet(
    context: navigatorKey.currentContext!,
    isScrollControlled: true,
    barrierColor: Colors.black.withOpacity(0.3),
    builder: (context) {
      if (scroll) {
        return SheetScrollModel(func: func, param: param);
      }
      return SheetModel(func: func, param: param);
    },
  );
}

void refreshLayer() {
  refreshLay.value = !refreshLay.value;
}

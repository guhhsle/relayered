import 'package:flutter/material.dart';
import 'data.dart';
import 'functions.dart';
import 'sheet_model.dart';
import 'sheet_scroll.dart';

class Setting {
  dynamic title, trailing;
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

void refreshLayer() {
  refreshLay.value = !refreshLay.value;
}

void showSheet({
  required Function(dynamic) func,
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

class LayerBuilder extends StatelessWidget {
  final Function(dynamic) func;
  final dynamic param;
  final Widget Function(BuildContext, AsyncSnapshot<Layer>) builder;
  const LayerBuilder({
    super.key,
    required this.func,
    required this.builder,
    this.param,
  });

  @override
  Widget build(BuildContext context) {
    if (func is Stream<Layer> Function(dynamic)) {
      Stream<Layer> Function(dynamic) f = func as Stream<Layer> Function(dynamic);
      return StreamBuilder(
        stream: f.call(param),
        builder: (context, snap) => builder(context, snap),
      );
    } else if (func is Future<Layer> Function(dynamic)) {
      Future<Layer> Function(dynamic) f = func as Future<Layer> Function(dynamic);
      return FutureBuilder(
        future: f.call(param),
        builder: builder,
      );
    } else {
      Layer Function(dynamic) f = func as Layer Function(dynamic);
      return builder(
        context,
        AsyncSnapshot.withData(
          ConnectionState.done,
          f.call(param),
        ),
      );
    }
  }
}

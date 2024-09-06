import 'package:flutter/material.dart';
import 'sheet_scroll.dart';
import 'sheet_model.dart';
import 'functions.dart';
import 'data.dart';

class Setting {
  void Function(BuildContext)? secondary;
  void Function(BuildContext)? onHold;
  void Function(BuildContext) onTap;
  dynamic title, trailing;
  Color? iconColor;
  IconData icon;

  Setting(
    this.title,
    this.icon,
    this.trailing,
    this.onTap, {
    this.secondary,
    this.onHold,
    this.iconColor,
  });

  Widget toTile(BuildContext context) {
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

    return Semantics(
      label: t(trailing),
      child: ListTile(
        leading: lead,
        title: Text(t(title)),
        trailing: trail,
        onTap: () {
          onTap(context);
          refreshLayer();
        },
        onLongPress: () {
          if (onHold == null) return;
          onHold!(context);
          refreshLayer();
        },
      ),
    );
  }
}

class Layer {
  List<Widget> Function(BuildContext)? leading, trailing;
  List<Setting> list;
  Setting action;

  Layer({
    required this.action,
    required this.list,
    this.trailing,
    this.leading,
  });
}

void refreshLayer() {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    refreshLay.value = !refreshLay.value;
  });
}

void showSheet({
  required Function(dynamic) func,
  dynamic param,
  bool scroll = false,
  BuildContext? hidePrev,
}) {
  if (hidePrev != null) Navigator.of(hidePrev).pop();
  showModalBottomSheet(
    barrierLabel: 'Barrier',
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
  final Widget Function(BuildContext, AsyncSnapshot<Layer>) builder;
  final Function(dynamic) func;
  final dynamic param;
  const LayerBuilder({
    super.key,
    required this.builder,
    required this.func,
    this.param,
  });

  @override
  Widget build(BuildContext context) {
    if (func is Stream<Layer> Function(dynamic)) {
      final f = func as Stream<Layer> Function(dynamic);
      return StreamBuilder(
        stream: f.call(param),
        builder: (context, snap) => builder(context, snap),
      );
    } else if (func is Future<Layer> Function(dynamic)) {
      final f = func as Future<Layer> Function(dynamic);
      return FutureBuilder(
        future: f.call(param),
        builder: builder,
      );
    } else {
      final f = func as Layer Function(dynamic);
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

import 'package:flutter/material.dart';
import 'sheet_scroll.dart';
import 'sheet_model.dart';
import 'data.dart';
import 'tile.dart';

class Layer {
  List<Widget> Function(BuildContext)? leading, trailing;
  List<Tile> list;
  Tile action;

  Layer({
    required this.action,
    required this.list,
    this.trailing,
    this.leading,
  });
}

void showScrollSheet(Function(Map) func, [Map? param]) {
  showModalBottomSheet(
    barrierLabel: 'Barrier',
    context: navigatorKey.currentContext!,
    isScrollControlled: true,
    barrierColor: Colors.black.withOpacity(0.3),
    builder: (c) => SheetScrollModel(func: func, param: param),
  );
}

void showSheet(Function(Map) func, [Map? param]) {
  showModalBottomSheet(
    barrierLabel: 'Barrier',
    context: navigatorKey.currentContext!,
    isScrollControlled: true,
    barrierColor: Colors.black.withOpacity(0.3),
    builder: (context) => SheetModel(func: func, param: param),
  );
}

class LayerBuilder extends StatelessWidget {
  final Widget Function(BuildContext, AsyncSnapshot<Layer>) builder;
  final Function(Map) func;
  final Map? param;
  const LayerBuilder({
    super.key,
    required this.builder,
    required this.func,
    this.param,
  });

  @override
  Widget build(BuildContext context) {
    if (func is Stream<Layer> Function(Map)) {
      final f = func as Stream<Layer> Function(Map);
      return StreamBuilder(
        stream: f.call(param ?? {}),
        builder: (context, snap) => builder(context, snap),
      );
    } else if (func is Future<Layer> Function(Map)) {
      final f = func as Future<Layer> Function(Map);
      return FutureBuilder(
        future: f.call(param ?? {}),
        builder: builder,
      );
    } else {
      final f = func as Layer Function(Map);
      return builder(
        context,
        AsyncSnapshot.withData(
          ConnectionState.done,
          f.call(param ?? {}),
        ),
      );
    }
  }
}

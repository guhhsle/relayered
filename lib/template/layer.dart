import 'package:flutter/material.dart';
import 'sheet_scroll.dart';
import 'sheet_model.dart';
import 'data.dart';
import 'tile.dart';

class Layer {
  Iterable<Widget>? leading, trailing;
  Iterable<Tile> list;
  BuildContext dirtyContext = navigatorKey.currentContext!;
  Tile action;
  Function(Layer) rebuild; //Rebuilds the template and returns it
  Map parameters; //Parameters for rebuilding

  Layer({
    required this.parameters,
    required this.rebuild,
    required this.action,
    required this.list,
    this.trailing,
    this.leading,
  });

  BuildContext get context {
    if (dirtyContext.mounted) {
      return dirtyContext;
    } else {
      return navigatorKey.currentContext!;
    }
  }

  static Layer template(Function(Layer) rebuild, Map parameters) {
    return Layer(
      action: Tile(),
      list: [],
      parameters: parameters,
      rebuild: rebuild,
    );
  }
}

void showScrollSheet(Function(Layer) rebuild, [Map? param]) {
  showModalBottomSheet(
    barrierLabel: 'Barrier',
    context: navigatorKey.currentContext!,
    isScrollControlled: true,
    barrierColor: Colors.black.withOpacity(0.3),
    builder: (c) => SheetScrollModel(
      template: Layer.template(rebuild, param ?? {}),
    ),
  );
}

void showSheet(Function(Layer) rebuild, [Map? param]) {
  showModalBottomSheet(
    barrierLabel: 'Barrier',
    context: navigatorKey.currentContext!,
    isScrollControlled: true,
    barrierColor: Colors.black.withOpacity(0.3),
    builder: (context) => SheetModel(
      template: Layer.template(rebuild, param ?? {}),
    ),
  );
}

class LayerBuilder extends StatelessWidget {
  final Widget Function(BuildContext, AsyncSnapshot<Layer>) builder;
  final Layer template;
  const LayerBuilder({
    super.key,
    required this.template,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    if (template.rebuild is Stream<Layer> Function(Layer)) {
      final f = template.rebuild as Stream<Layer> Function(Layer);
      return StreamBuilder(
        stream: f.call(template),
        builder: (context, snap) => builder(context, snap),
      );
    } else if (template.rebuild is Future<Layer> Function(Layer)) {
      final f = template.rebuild as Future<Layer> Function(Layer);
      return FutureBuilder(
        future: f.call(template),
        builder: builder,
      );
    } else {
      final f = template.rebuild as Layer Function(Layer);
      return builder(
        context,
        AsyncSnapshot.withData(
          ConnectionState.done,
          f.call(template),
        ),
      );
    }
  }
}

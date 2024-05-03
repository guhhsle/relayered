import 'package:flutter/material.dart';
import 'custom_card.dart';
import 'data.dart';
import 'layer.dart';

class SheetModel extends StatelessWidget {
  final Future<Layer> Function(dynamic) func;
  final dynamic param;
  const SheetModel({
    super.key,
    required this.func,
    required this.param,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      color: Theme.of(context).colorScheme.background.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ValueListenableBuilder(
          valueListenable: refreshLay,
          builder: (context, non, child) => FutureBuilder(
            future: func.call(param),
            builder: (context, snap) {
              if (!snap.hasData) return Container();
              Layer layer = snap.data!;
              final list = layer.list;
              return ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Row(
                    children: (layer.leading == null ? <Widget>[] : layer.leading!(context)) +
                        [
                          Expanded(
                            child: CustomCard(layer.action),
                          )
                        ] +
                        (layer.trailing == null ? [] : layer.trailing!(context)),
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: list.length,
                    itemBuilder: (context, i) => list[i].toTile(context),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'custom_card.dart';
import 'layer.dart';
import 'data.dart';

class SheetModel extends StatelessWidget {
  final Function(dynamic) func;
  final dynamic param;

  const SheetModel({
    super.key,
    required this.param,
    required this.func,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Static bottom sheet',
      child: Card(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
        margin: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ValueListenableBuilder(
            valueListenable: refreshLay,
            builder: (context, non, child) => LayerBuilder(
              func: func,
              param: param,
              builder: (context, snap) {
                if (!snap.hasData) return Container();
                Layer layer = snap.data!;
                final list = layer.list;
                return ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Row(
                      children: [
                        if (layer.leading != null) ...layer.leading!(context),
                        Expanded(child: CustomCard(layer.action)),
                        if (layer.trailing != null) ...layer.trailing!(context),
                      ],
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: list.length,
                      shrinkWrap: true,
                      itemBuilder: (c, i) => list[i].toTile(c),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

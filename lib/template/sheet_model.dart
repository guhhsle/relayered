import 'package:flutter/material.dart';
import 'custom_card.dart';
import 'layer.dart';

class SheetModel extends StatelessWidget {
  final Layer layer;

  const SheetModel({
    super.key,
    required this.layer,
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
          child: ListenableBuilder(
            listenable: layer,
            builder: (context, child) {
              layer.dirtyContext = context;
              layer.construct();
              return ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Row(
                    children: [
                      ...layer.leading,
                      Expanded(child: CustomCard(layer.action)),
                      ...layer.trailing,
                    ],
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: layer.list.length,
                    shrinkWrap: true,
                    itemBuilder: (c, i) => layer.list.elementAt(i).toWidget,
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

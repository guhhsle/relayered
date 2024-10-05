import 'package:flutter/material.dart';
import 'custom_card.dart';
import 'layer.dart';

class SheetScrollModel extends StatelessWidget {
  final Layer layer;
  const SheetScrollModel({
    super.key,
    required this.layer,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Scrollable bottom sheet',
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          color: Colors.transparent,
          child: DraggableScrollableSheet(
            initialChildSize: 0.6,
            maxChildSize: 0.8,
            minChildSize: 0.2,
            builder: (context, controller) => Card(
              margin: const EdgeInsets.all(8),
              color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: ListenableBuilder(
                  listenable: layer,
                  builder: (context, snap) {
                    layer.dirtyContext = context;
                    layer.construct();
                    return Column(
                      children: [
                        Row(
                          children: [
                            ...layer.leading,
                            Expanded(child: CustomCard(layer.action)),
                            ...layer.trailing,
                          ],
                        ),
                        Expanded(
                          child: Scrollbar(
                            controller: controller,
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.only(bottom: 8),
                              controller: controller,
                              itemCount: layer.list.length,
                              itemBuilder: (c, i) =>
                                  layer.list.elementAt(i).toWidget,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

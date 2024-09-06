import 'package:flutter/material.dart';
import 'custom_card.dart';
import 'layer.dart';
import 'data.dart';

class SheetScrollModel extends StatelessWidget {
  final Function(dynamic) func;
  final dynamic param;
  const SheetScrollModel({
    super.key,
    required this.param,
    required this.func,
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
                child: ValueListenableBuilder(
                  valueListenable: refreshLay,
                  builder: (context, non, child) => LayerBuilder(
                    func: func,
                    param: param,
                    builder: (context, snap) {
                      if (!snap.hasData) return Container();
                      Layer layer = snap.data!;
                      List<Setting> list = layer.list;
                      return Column(
                        children: [
                          Row(
                            children: [
                              if (layer.leading != null)
                                ...layer.leading!(context),
                              Expanded(child: CustomCard(layer.action)),
                              if (layer.trailing != null)
                                ...layer.trailing!(context),
                            ],
                          ),
                          Expanded(
                            child: Scrollbar(
                              controller: controller,
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.only(bottom: 8),
                                controller: controller,
                                itemCount: list.length,
                                itemBuilder: (c, i) => list[i].toTile(c),
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
      ),
    );
  }
}

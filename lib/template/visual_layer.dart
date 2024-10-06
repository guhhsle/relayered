import 'package:flutter/material.dart';
import 'tile_card.dart';
import 'layer.dart';

class VisualLayer extends StatefulWidget {
  final Layer layer;

  const VisualLayer({super.key, required this.layer});

  @override
  State<VisualLayer> createState() => _VisualLayerState();
}

class _VisualLayerState extends State<VisualLayer> {
  void layerChange() {
    widget.layer.construct();
    setState(() {});
  }

  @override
  void initState() {
    for (var listenable in widget.layer.listened) {
      listenable.addListener(layerChange);
    }
    super.initState();
  }

  @override
  void dispose() {
    for (var listenable in widget.layer.listened) {
      listenable.removeListener(layerChange);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.layer.dirtyContext = context;
    return Semantics(
      label: 'Bottom sheet',
      child: ListenableBuilder(
        listenable: widget.layer,
        builder: (c, child) {
          final list = widget.layer.list.map((e) => e.toWidget);
          if (widget.layer.scroll) {
            return GestureDetector(
              onTap: () => Navigator.of(c).pop(),
              child: Container(
                color: Colors.transparent,
                child: DraggableScrollableSheet(
                  initialChildSize: 0.6,
                  maxChildSize: 0.8,
                  minChildSize: 0.2,
                  builder: (c, controller) => Card(
                    margin: const EdgeInsets.all(8),
                    color: Theme.of(c).colorScheme.surface.withOpacity(0.8),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Row(children: [
                            ...widget.layer.leading,
                            Expanded(child: TileCard(widget.layer.action)),
                            ...widget.layer.trailing,
                          ]),
                          Expanded(
                            child: Scrollbar(
                              controller: controller,
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.only(bottom: 8),
                                controller: controller,
                                itemCount: list.length,
                                itemBuilder: (c, i) => list.elementAt(i),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Card(
              color: Theme.of(c).colorScheme.surface.withOpacity(0.8),
              margin: const EdgeInsets.all(8),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(children: [
                      ...widget.layer.leading,
                      Expanded(child: TileCard(widget.layer.action)),
                      ...widget.layer.trailing,
                    ]),
                    ...list,
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

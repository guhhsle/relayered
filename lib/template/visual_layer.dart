import 'package:flutter/material.dart';
import 'tile_card.dart';
import 'layer.dart';

class VisualLayer extends StatefulWidget {
  final Layer layer;
  const VisualLayer({
    super.key,
    required this.layer,
  });

  @override
  State<VisualLayer> createState() => _VisualLayerState();
}

class _VisualLayerState extends State<VisualLayer> {
  @override
  void initState() {
    widget.layer.construct();
    widget.layer.initListeners();
    super.initState();
  }

  @override
  void dispose() {
    widget.layer.disposeListeners();
    super.dispose();
  }

  ThemeData modTheme(BuildContext c) {
    return Theme.of(c).copyWith(
      cardTheme: Theme.of(c).cardTheme.copyWith(
            elevation: 6,
            margin: const EdgeInsets.all(8),
            color: Theme.of(c).colorScheme.surface.withValues(alpha: 0.8),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Bottom sheet',
      child: ListenableBuilder(
        listenable: widget.layer,
        builder: (c, child) => Theme(
          data: modTheme(c),
          child: Builder(
            builder: (c) {
              widget.layer.dirtyContext = c;
              final list = widget.layer.list.map((e) => e.toWidget);
              if (list.length > 6) {
                return GestureDetector(
                  onTap: () => Navigator.of(c).pop(),
                  child: Container(
                    color: Colors.transparent,
                    child: DraggableScrollableSheet(
                      initialChildSize: 0.6,
                      maxChildSize: 0.8,
                      minChildSize: 0.2,
                      builder: (c, controller) => Card(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  ...widget.layer.leading,
                                  Expanded(
                                    child: TileCard(widget.layer.action),
                                  ),
                                  ...widget.layer.trailing,
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
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            ...widget.layer.leading,
                            Expanded(child: TileCard(widget.layer.action)),
                            ...widget.layer.trailing,
                          ],
                        ),
                        ...list,
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

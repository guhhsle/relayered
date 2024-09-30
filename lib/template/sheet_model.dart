import 'package:flutter/material.dart';
import 'custom_card.dart';
import 'layer.dart';
import '../../template/prefs.dart';

class SheetModel extends StatelessWidget {
  final Function(Map) func;
  final Map? param;

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
          child: ListenableBuilder(
            listenable: Preferences(),
            builder: (context, child) => LayerBuilder(
              func: func,
              param: param,
              builder: (c, snap) {
                if (!snap.hasData) return Container();
                Layer ly = snap.data!;
                return ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Row(
                      children: [
                        if (ly.leading != null) ...ly.leading!(c),
                        Expanded(child: CustomCard(ly.action)),
                        if (ly.trailing != null) ...ly.trailing!(c),
                      ],
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: ly.list.length,
                      shrinkWrap: true,
                      itemBuilder: (c, i) => ly.list[i].toWidget(c),
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

import 'package:flutter/material.dart';
import 'functions.dart';
import 'prefs.dart';
import 'tile.dart';

class CustomChip extends StatelessWidget {
  final bool selected, showCheckmark;
  final Color? primary, background;
  final Tile tile;

  const CustomChip({
    super.key,
    this.showCheckmark = false,
    required this.selected,
    required this.tile,
    this.background,
    this.primary,
  });

  @override
  Widget build(BuildContext context) {
    Color pr = primary ?? Theme.of(context).primaryColor;
    Color bg = background ?? Theme.of(context).colorScheme.surface;
    return ListenableBuilder(
      listenable: Preferences(),
      builder: (context, child) => Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Semantics(
          label: tile.title,
          child: InkWell(
            onLongPress: () => tile.onHold?.call(context),
            child: InputChip(
              showCheckmark: showCheckmark,
              avatar: Icon(tile.icon, color: selected ? bg : pr),
              onSelected: (val) => tile.onTap?.call(context),
              selected: selected,
              backgroundColor: bg,
              selectedColor: pr,
              label: Text(
                t(tile.title),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: selected ? bg : pr,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

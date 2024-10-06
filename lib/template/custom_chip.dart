import 'package:flutter/material.dart';
import 'functions.dart';
import 'prefs.dart';
import 'tile.dart';

class TileChip extends StatelessWidget {
  final bool selected, showCheckmark;
  final bool showAvatar;
  final Color? primary, background;
  final Tile tile;

  const TileChip({
    super.key,
    this.showCheckmark = false,
    required this.selected,
    required this.tile,
    this.background,
    this.showAvatar = true,
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
            onLongPress: tile.onHold,
            child: InputChip(
              showCheckmark: showCheckmark,
              avatar: showAvatar
                  ? Icon(tile.icon, color: selected ? bg : pr)
                  : null,
              onSelected: (val) => tile.onTap?.call(),
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

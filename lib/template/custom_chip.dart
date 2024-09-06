import 'package:flutter/material.dart';
import 'functions.dart';

class CustomChip extends StatelessWidget {
  final void Function(bool value) onSelected;
  final bool selected, showCheckmark;
  final Color? primary, background;
  final void Function()? onHold;
  final Widget? avatar;
  final String label;

  const CustomChip({
    super.key,
    this.showCheckmark = false,
    required this.onSelected,
    required this.selected,
    required this.label,
    this.background,
    this.primary,
    this.onHold,
    this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    Color pr = primary ?? Theme.of(context).primaryColor;
    Color bg = background ?? Theme.of(context).colorScheme.surface;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Semantics(
        label: label,
        child: InkWell(
          onLongPress: onHold,
          child: InputChip(
            showCheckmark: showCheckmark,
            avatar: avatar,
            selected: selected,
            onSelected: onSelected,
            backgroundColor: bg,
            selectedColor: pr,
            label: Text(
              t(label),
              style: TextStyle(
                color: selected ? bg : pr,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

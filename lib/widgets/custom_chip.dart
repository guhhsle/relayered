import 'package:flutter/material.dart';

import '../data.dart';

class CustomChip extends StatefulWidget {
  final void Function(bool value) onSelected;
  final void Function() onHold;
  final bool selected;
  final String label;
  final Color? primary, background;

  const CustomChip({
    super.key,
    required this.onSelected,
    required this.onHold,
    required this.selected,
    required this.label,
    this.primary,
    this.background,
  });

  @override
  State<CustomChip> createState() => _CustomChipState();
}

class _CustomChipState extends State<CustomChip> {
  @override
  Widget build(BuildContext context) {
    Color primary = widget.primary ?? Theme.of(context).primaryColor;
    Color background = widget.background ?? Theme.of(context).colorScheme.background;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onLongPress: widget.onHold,
        child: InputChip(
          showCheckmark: false,
          selected: widget.selected,
          onSelected: widget.onSelected,
          backgroundColor: background,
          selectedColor: primary,
          label: Text(
            l[widget.label] ?? widget.label,
            style: TextStyle(
              color: widget.selected ? background : primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

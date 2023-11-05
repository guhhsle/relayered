import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  final Widget child;

  const Body({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.background,
      margin: EdgeInsets.zero,
      shadowColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(32),
          topLeft: Radius.circular(16),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(32),
          topLeft: Radius.circular(16),
        ),
        child: child,
      ),
    );
  }
}

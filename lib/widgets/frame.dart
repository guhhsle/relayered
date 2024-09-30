import 'package:flutter/material.dart';

class Frame extends StatelessWidget {
  final Widget title;
  final List<Widget> actions;
  final Widget? child;
  final bool automaticallyImplyLeading;
  final Widget? floatingActionButton;
  final Widget? leading;

  const Frame({
    super.key,
    this.title = const SizedBox(),
    this.actions = const [],
    this.child,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: floatingActionButton,
      appBar: AppBar(
        title: title,
        leading: leading,
        automaticallyImplyLeading: automaticallyImplyLeading,
        actions: [...actions, const SizedBox(width: 8)],
      ),
      body: SizedBox(
        height: double.infinity,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(32),
            topLeft: Radius.circular(16),
          ),
          child: Card(
            color: Theme.of(context).colorScheme.surface,
            margin: EdgeInsets.zero,
            shadowColor: Colors.transparent,
            shape: const RoundedRectangleBorder(),
            child: ClipRRect(child: child),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'tile_card.dart';
import 'data.dart';
import 'tile.dart';
import '../data.dart';

Future<void> singleChildSheet({
  required Tile action,
  required Widget child,
  double initialSize = 0.4,
}) async {
  showModalBottomSheet(
    context: navigatorKey.currentContext!,
    isScrollControlled: true,
    builder: (context) {
      return Container(
        color: Colors.transparent,
        child: DraggableScrollableSheet(
          initialChildSize: initialSize,
          maxChildSize: 0.9,
          minChildSize: 0.2,
          builder: (_, controller) {
            return Card(
              margin: const EdgeInsets.all(8),
              color: Theme.of(
                context,
              ).colorScheme.surface.withValues(alpha: 0.8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    TileCard(action),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          vertical: 32,
                          horizontal: 8,
                        ),
                        physics: scrollPhysics,
                        controller: controller,
                        child: Center(
                          child: DefaultTextStyle(
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontFamily: Pref.font.value,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            child: child,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    },
  );
}

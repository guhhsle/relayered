import 'package:flutter/material.dart';
import '../data.dart';
import 'custom_card.dart';
import 'data.dart';
import 'layer.dart';

Future<void> singleChildSheet({
  required Setting action,
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
              color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    CustomCard(action),
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
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.primary,
                              fontFamily: pf['font'],
                              fontWeight: FontWeight.bold,
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

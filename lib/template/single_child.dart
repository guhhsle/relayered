import 'package:flutter/material.dart';
import '../data.dart';
import 'custom_card.dart';
import 'data.dart';
import 'layer.dart';

Future<void> singleChildSheet({
  required String title,
  required IconData icon,
  required Widget child,
  required BuildContext context,
}) async {
  Navigator.of(context).pop();
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return Container(
        color: Colors.transparent,
        child: DraggableScrollableSheet(
          initialChildSize: 0.4,
          maxChildSize: 0.9,
          minChildSize: 0.2,
          builder: (_, controller) {
            return Card(
              margin: const EdgeInsets.all(8),
              color: Theme.of(context).colorScheme.background.withOpacity(0.8),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    CustomCard(Setting(title, icon, '', (c) {})),
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

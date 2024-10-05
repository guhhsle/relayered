import 'package:flutter/material.dart';
import 'functions.dart';
import 'tile.dart';

class CustomCard extends StatelessWidget {
  final Tile tile;
  final EdgeInsets margin;
  final double height;

  const CustomCard(
    this.tile, {
    super.key,
    this.margin = const EdgeInsets.symmetric(
      vertical: 16,
      horizontal: 8,
    ),
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: t(tile.title),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Card(
          elevation: 6,
          shadowColor: Theme.of(context).colorScheme.primary,
          margin: margin,
          color: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: tile.onTap,
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: SizedBox(
              width: double.infinity,
              height: height,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 22),
                      child: Text(
                        t(tile.title),
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: tile.trailing == ''
                        ? Icon(
                            tile.icon,
                            color: Theme.of(context).colorScheme.surface,
                          )
                        : Text(
                            t(tile.trailing),
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

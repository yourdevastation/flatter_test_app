import 'package:flutter/material.dart';

/// Круглая подложка для кнопок AppBar, чтобы они читались поверх фото.
class AppBarCircle extends StatelessWidget {
  const AppBarCircle({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.85),
          shape: BoxShape.circle,
        ),
        child: child,
      ),
    );
  }
}

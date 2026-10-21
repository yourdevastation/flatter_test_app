import 'package:flutter/material.dart';

class LikeIcon extends StatelessWidget {
  const LikeIcon({super.key, required this.isLiked, this.size = 24});

  final bool isLiked;
  final double size;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      switchInCurve: Curves.easeOutBack,
      transitionBuilder: (child, animation) =>
          ScaleTransition(scale: animation, child: child),
      // Без разных ключей AnimatedSwitcher посчитает иконки одним виджетом
      // и не запустит анимацию.
      child: isLiked
          ? Icon(
              Icons.favorite,
              key: const ValueKey(true),
              size: size,
              color: Colors.redAccent,
            )
          : Icon(
              Icons.favorite_border,
              key: const ValueKey(false),
              size: size,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
    );
  }
}

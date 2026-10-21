import 'package:flutter/material.dart';

String taskImageHeroTag(String taskId) => 'task-image-$taskId';

class TaskImage extends StatelessWidget {
  const TaskImage({
    super.key,
    required this.url,
    required this.heroTag,
    this.isDimmed = false,
  });

  final String url;
  final String heroTag;
  final bool isDimmed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // Декодируем картинку под реальную ширину экрана, а не в исходном размере.
    // Ширина одинаковая на списке и в деталях, поэтому кэш переиспользуется.
    final cacheWidth =
        (MediaQuery.sizeOf(context).width *
                MediaQuery.devicePixelRatioOf(context))
            .round();

    return Hero(
      tag: heroTag,
      child: Image.network(
        url,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        cacheWidth: cacheWidth,
        color: isDimmed ? colorScheme.surface.withValues(alpha: 0.55) : null,
        colorBlendMode: BlendMode.srcATop,
        loadingBuilder: (context, child, progress) {
          if (progress == null) {
            return child;
          }

          return ColoredBox(
            color: colorScheme.surfaceContainerHighest,
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) =>
            Placeholder(color: colorScheme.outlineVariant),
      ),
    );
  }
}

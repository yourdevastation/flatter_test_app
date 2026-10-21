import 'package:flutter/material.dart';
import 'package:flutter_test_app/features/tasks/presentation/models/task_card_data.dart';

class TaskCard extends StatelessWidget {
  const TaskCard.fromData(
    this.data, {
    super.key,
    this.leading,
    this.trailing,
    this.onTap,
  });

  static const double _radius = 16;
  static const double _imageHeight = 140;

  final TaskCardData data;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final borderRadius = BorderRadius.circular(_radius);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      // Прозрачный Material нужен, чтобы ripple от InkWell рисовался
      // поверх фона из BoxDecoration, а не под ним.
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _CardImage(
                url: data.imageUrl,
                height: _imageHeight,
                radius: _radius,
                isDimmed: data.isCompleted,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 12, 12),
                child: Row(
                  children: [
                    ?leading,
                    Expanded(child: _CardContent(data: data)),
                    if (trailing != null) ...[
                      const SizedBox(width: 8),
                      trailing!,
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardImage extends StatelessWidget {
  const _CardImage({
    required this.url,
    required this.height,
    required this.radius,
    required this.isDimmed,
  });

  final String url;
  final double height;
  final double radius;
  final bool isDimmed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // Декодируем картинку под реальную ширину экрана, а не в исходном размере.
    final cacheWidth =
        (MediaQuery.sizeOf(context).width *
                MediaQuery.devicePixelRatioOf(context))
            .round();

    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(radius)),
      child: SizedBox(
        height: height,
        child: Image.network(
          url,
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
      ),
    );
  }
}

class _CardContent extends StatelessWidget {
  const _CardContent({required this.data});

  final TaskCardData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final caption = data.caption;
    final description = data.description;

    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(data.icon, size: 16, color: colorScheme.primary),
              if (caption != null) ...[
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    caption,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.primary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            data.title,
            style: theme.textTheme.titleMedium?.copyWith(
              decoration: data.isCompleted ? TextDecoration.lineThrough : null,
              color: data.isCompleted ? colorScheme.outline : null,
            ),
          ),
          if (description != null) ...[
            const SizedBox(height: 2),
            Text(
              description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

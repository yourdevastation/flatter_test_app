import 'package:flutter/material.dart';
import 'package:flutter_test_app/core/l10n/l10n.dart';
import 'package:flutter_test_app/features/tasks/domain/entities/task_stats.dart';

class StatsCard extends StatelessWidget {
  const StatsCard({super.key, required this.stats});

  final TaskStats stats;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _StatItem(
              label: l10n.statsTotal,
              value: '${stats.total}',
              color: colorScheme.primary,
            ),
            _StatItem(
              label: l10n.statsCompleted,
              value: '${stats.completed}',
              color: colorScheme.tertiary,
            ),
            _StatItem(
              label: l10n.statsActive,
              value: '${stats.active}',
              color: colorScheme.secondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }
}

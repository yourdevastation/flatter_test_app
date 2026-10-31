import 'package:flutter/material.dart';
import 'package:flutter_test_app/core/l10n/l10n.dart';
import 'package:flutter_test_app/core/extensions/task_priority_extension.dart';
import 'package:flutter_test_app/features/tasks/domain/entities/task_priority.dart';

class PriorityChip extends StatelessWidget {
  const PriorityChip({super.key, required this.priority});

  final TaskPriority priority;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(priority.label(context.l10n)),
      backgroundColor: priority.color.withValues(alpha: 0.2),
      labelStyle: TextStyle(color: priority.color),
      side: BorderSide.none,
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

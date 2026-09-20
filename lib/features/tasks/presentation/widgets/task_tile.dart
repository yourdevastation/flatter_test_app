import 'package:flutter/material.dart';
import 'package:flutter_test_app/core/extensions/task_priority_extension.dart';
import 'package:flutter_test_app/features/tasks/domain/entities/task.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({super.key, required this.task, required this.onToggle});

  final Task task;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (_) => onToggle(),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            color: task.isCompleted ? colorScheme.outline : null,
          ),
        ),
        trailing: Chip(
          label: Text(task.priority.label),
          backgroundColor: task.priority.color.withValues(alpha: 0.2),
          labelStyle: TextStyle(color: task.priority.color),
          side: BorderSide.none,
          padding: EdgeInsets.zero,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onTap: () => onToggle(),
      ),
    );
  }
}

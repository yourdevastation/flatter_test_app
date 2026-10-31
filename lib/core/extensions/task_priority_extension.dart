import 'package:flutter/material.dart';

import 'package:flutter_test_app/core/l10n/l10n.dart';
import 'package:flutter_test_app/features/tasks/domain/entities/task_priority.dart';

extension TaskPriorityExtension on TaskPriority {
  Color get color => switch (this) {
    TaskPriority.low => Colors.green,
    TaskPriority.medium => Colors.orange,
    TaskPriority.high => Colors.red,
  };

  String label(AppLocale l10n) => switch (this) {
    TaskPriority.low => l10n.priorityLow,
    TaskPriority.medium => l10n.priorityMedium,
    TaskPriority.high => l10n.priorityHigh,
  };
}

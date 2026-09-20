import 'package:flutter/material.dart';

import 'package:flutter_test_app/features/tasks/domain/entities/task_priority.dart';

extension TaskPriorityExtension on TaskPriority {
  Color get color => switch (this) {
    TaskPriority.low => Colors.green,
    TaskPriority.medium => Colors.orange,
    TaskPriority.high => Colors.red,
  };
}
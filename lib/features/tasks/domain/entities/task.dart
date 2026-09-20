import 'package:flutter_test_app/features/tasks/domain/entities/task_priority.dart';

class Task {
  final String id;
  final String title;
  final bool isCompleted;
  final TaskPriority priority;

  const Task({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.priority,
  });

  Task copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    TaskPriority? priority,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
    );
  }
}
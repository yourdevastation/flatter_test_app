import 'package:flutter_test_app/features/tasks/domain/entities/task_category.dart';
import 'package:flutter_test_app/features/tasks/domain/entities/task_priority.dart';

class Task {
  final String id;
  final String title;
  final String? description;
  final bool isCompleted;
  final TaskPriority priority;
  final TaskCategory category;

  const Task({
    required this.id,
    required this.title,
    this.description,
    required this.isCompleted,
    required this.priority,
    required this.category,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    TaskPriority? priority,
    TaskCategory? category,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      category: category ?? this.category,
    );
  }
}

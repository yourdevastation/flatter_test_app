import 'package:flutter_test_app/features/tasks/domain/entities/task_category.dart';
import 'package:flutter_test_app/features/tasks/domain/entities/task_priority.dart';

class Task {
  final String id;
  final String title;
  final String? description;
  final bool isCompleted;
  final bool isFavorite;
  final TaskPriority priority;
  final TaskCategory category;
  final DateTime createdAt;

  const Task({
    required this.id,
    required this.title,
    this.description,
    required this.isCompleted,
    this.isFavorite = false,
    required this.priority,
    required this.category,
    required this.createdAt,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    bool? isFavorite,
    TaskPriority? priority,
    TaskCategory? category,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      isFavorite: isFavorite ?? this.isFavorite,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

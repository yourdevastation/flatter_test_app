import 'package:flutter_test_app/core/models/result.dart';
import 'package:flutter_test_app/features/tasks/domain/entities/task.dart';
import 'package:flutter_test_app/features/tasks/domain/entities/task_category.dart';
import 'package:flutter_test_app/features/tasks/domain/entities/task_priority.dart';

abstract interface class TaskRepository {
  Future<Result<List<Task>>> getTasks();

  Future<Result<Task>> addTask({
    required String title,
    String? description,
    required TaskPriority priority,
    required TaskCategory category,
  });

  Future<Result<Task>> toggleTask(String id);

  Future<Result<Task>> setFavorite(String id, {required bool isFavorite});
}

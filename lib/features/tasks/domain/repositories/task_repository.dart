import 'package:flutter_test_app/core/models/result.dart';
import 'package:flutter_test_app/features/tasks/domain/entities/task.dart';
import 'package:flutter_test_app/features/tasks/domain/entities/task_priority.dart';

abstract interface class TaskRepository {
  Future<Result<List<Task>>> getTasks();

  Future<Result<Task>> addTask(String title, TaskPriority priority);

  Future<Result<Task>> toggleTask(String id);
}
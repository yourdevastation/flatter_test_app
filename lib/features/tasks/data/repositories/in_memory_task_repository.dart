import 'package:flutter_test_app/core/models/app_failure.dart';
import 'package:flutter_test_app/core/models/result.dart';
import 'package:flutter_test_app/features/tasks/data/seed/initial_tasks.dart';
import 'package:flutter_test_app/features/tasks/domain/entities/task.dart';
import 'package:flutter_test_app/features/tasks/domain/entities/task_category.dart';
import 'package:flutter_test_app/features/tasks/domain/entities/task_priority.dart';
import 'package:flutter_test_app/features/tasks/domain/repositories/task_repository.dart';

/// Задачи в памяти, без сохранения. В приложении теперь используется
/// DriftTaskRepository; этот класс — мок-реализация того же интерфейса.
class InMemoryTaskRepository implements TaskRepository {
  final List<Task> _tasks = buildInitialTasks();

  @override
  Future<Result<List<Task>>> getTasks() async {
    await Future<void>.delayed(const Duration(seconds: 1));

    return Result.success(List<Task>.from(_tasks));
  }

  @override
  Future<Result<Task>> addTask({
    required String title,
    String? description,
    required TaskPriority priority,
    required TaskCategory category,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    final task = Task(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      description: description,
      isCompleted: false,
      priority: priority,
      category: category,
      createdAt: DateTime.now(),
    );

    _tasks.insert(0, task);

    return Result.success(task);
  }

  @override
  Future<Result<Task>> toggleTask(String id) {
    return _updateTask(
      id,
      (task) => task.copyWith(isCompleted: !task.isCompleted),
    );
  }

  @override
  Future<Result<Task>> setFavorite(String id, {required bool isFavorite}) {
    return _updateTask(id, (task) => task.copyWith(isFavorite: isFavorite));
  }

  Future<Result<Task>> _updateTask(
    String id,
    Task Function(Task task) update,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    final index = _tasks.indexWhere((task) => task.id == id);

    if (index == -1) {
      return const Result.failure(AppFailure.notFound);
    }

    final updatedTask = update(_tasks[index]);

    _tasks[index] = updatedTask;

    return Result.success(updatedTask);
  }
}

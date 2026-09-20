import 'package:flutter_test_app/core/models/result.dart';
import 'package:flutter_test_app/features/tasks/domain/entities/task.dart';
import 'package:flutter_test_app/features/tasks/domain/entities/task_priority.dart';
import 'package:flutter_test_app/features/tasks/domain/repositories/task_repository.dart';

class InMemoryTaskRepository implements TaskRepository {
  final List<Task> _tasks = [];

  InMemoryTaskRepository() {
    _generateInitialTasks();
  }

  void _generateInitialTasks() {
    const initialData = [
      ('Изучить основы Flutter', TaskPriority.high),
      ('Выполнить лабораторную работу', TaskPriority.high),
      ('Посмотреть видео про MVVM', TaskPriority.medium),
      ('Составить список покупок', TaskPriority.low),
    ];

    for (var i = 0; i < initialData.length; i++) {
      final (title, priority) = initialData[i];

      _tasks.add(
        Task(
          id: 'task_$i',
          title: title,
          isCompleted: i % 2 == 0,
          priority: priority,
        ),
      );
    }
  }

  @override
  Future<Result<List<Task>>> getTasks() async {
    await Future<void>.delayed(const Duration(seconds: 1));

    return Result.success(List<Task>.from(_tasks));
  }

  @override
  Future<Result<Task>> addTask(String title, TaskPriority priority) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    final task = Task(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      isCompleted: false,
      priority: priority,
    );

    _tasks.add(task);

    return Result.success(task);
  }

  @override
  Future<Result<Task>> toggleTask(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    final index = _tasks.indexWhere((task) => task.id == id);

    if (index == -1) {
      return const Result.failure('Задача не найдена');
    }

    final updatedTask = _tasks[index].copyWith(
      isCompleted: !_tasks[index].isCompleted,
    );

    _tasks[index] = updatedTask;

    return Result.success(updatedTask);
  }
}

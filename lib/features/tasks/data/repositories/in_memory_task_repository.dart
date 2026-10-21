import 'package:flutter_test_app/core/models/result.dart';
import 'package:flutter_test_app/features/tasks/domain/entities/task.dart';
import 'package:flutter_test_app/features/tasks/domain/entities/task_category.dart';
import 'package:flutter_test_app/features/tasks/domain/entities/task_priority.dart';
import 'package:flutter_test_app/features/tasks/domain/repositories/task_repository.dart';

class InMemoryTaskRepository implements TaskRepository {
  final List<Task> _tasks = [];

  InMemoryTaskRepository() {
    _generateInitialTasks();
  }

  void _generateInitialTasks() {
    const initialData = [
      (
        'Изучить основы Flutter',
        'Виджеты, layout и работа с состоянием',
        TaskPriority.high,
        TaskCategory.study,
      ),
      (
        'Выполнить лабораторную работу',
        'Список карточек с картинкой, иконкой и текстом',
        TaskPriority.high,
        TaskCategory.study,
      ),
      (
        'Подготовить отчёт по проекту',
        'Собрать результаты спринта и отправить команде',
        TaskPriority.medium,
        TaskCategory.work,
      ),
      (
        'Составить список покупок',
        'Овощи, крупы и что-нибудь к чаю',
        TaskPriority.low,
        TaskCategory.shopping,
      ),
      ('Сходить на тренировку', null, TaskPriority.medium, TaskCategory.health),
      (
        'Навести порядок на кухне',
        'Помыть посуду и разобрать шкафчики',
        TaskPriority.low,
        TaskCategory.home,
      ),
    ];

    for (var i = 0; i < initialData.length; i++) {
      final (title, description, priority, category) = initialData[i];

      _tasks.add(
        Task(
          id: 'task_$i',
          title: title,
          description: description,
          isCompleted: i % 2 == 0,
          priority: priority,
          category: category,
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

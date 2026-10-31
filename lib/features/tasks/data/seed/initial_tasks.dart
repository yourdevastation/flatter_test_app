import 'package:flutter_test_app/features/tasks/domain/entities/task.dart';
import 'package:flutter_test_app/features/tasks/domain/entities/task_category.dart';
import 'package:flutter_test_app/features/tasks/domain/entities/task_priority.dart';

/// Демо-задачи для первого запуска. Это данные пользователя, а не текст
/// интерфейса, поэтому они не переводятся.
List<Task> buildInitialTasks() {
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

  final now = DateTime.now();

  return [
    for (var i = 0; i < initialData.length; i++)
      Task(
        id: 'task_$i',
        title: initialData[i].$1,
        description: initialData[i].$2,
        isCompleted: i % 2 == 0,
        isFavorite: i == 1,
        priority: initialData[i].$3,
        category: initialData[i].$4,
        createdAt: now.subtract(Duration(days: i * 2)),
      ),
  ];
}

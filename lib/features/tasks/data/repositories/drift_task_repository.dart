import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test_app/core/database/app_database.dart';
import 'package:flutter_test_app/core/models/app_failure.dart';
import 'package:flutter_test_app/core/models/result.dart';
import 'package:flutter_test_app/features/tasks/data/mappers/task_row_mapper.dart';
import 'package:flutter_test_app/features/tasks/domain/entities/task.dart';
import 'package:flutter_test_app/features/tasks/domain/entities/task_category.dart';
import 'package:flutter_test_app/features/tasks/domain/entities/task_priority.dart';
import 'package:flutter_test_app/features/tasks/domain/repositories/task_repository.dart';

/// Задачи в SQLite. Реализует тот же интерфейс, что InMemoryTaskRepository,
/// поэтому view model не заметила замены.
class DriftTaskRepository implements TaskRepository {
  DriftTaskRepository(this._db);

  final AppDatabase _db;

  $TasksTableTable get _tasks => _db.tasksTable;

  @override
  Future<Result<List<Task>>> getTasks() => _guard(() async {
    // SELECT * FROM tasks ORDER BY created_at DESC
    final query = _db.select(_tasks)
      ..orderBy([(task) => OrderingTerm.desc(task.createdAt)]);
    final rows = await query.get();

    return rows.map((row) => row.toDomain()).toList();
  });

  @override
  Future<Result<Task>> addTask({
    required String title,
    String? description,
    required TaskPriority priority,
    required TaskCategory category,
  }) => _guard(() async {
    final task = Task(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      description: description,
      isCompleted: false,
      priority: priority,
      category: category,
      createdAt: DateTime.now(),
    );

    await _db.into(_tasks).insert(task.toCompanion());

    return task;
  });

  @override
  Future<Result<Task>> toggleTask(String id) {
    // UPDATE tasks SET is_completed = NOT is_completed WHERE id = ?
    // Переключение делает сама база одним запросом, без чтения перед записью.
    return _update(
      id,
      TasksTableCompanion.custom(isCompleted: _tasks.isCompleted.not()),
    );
  }

  @override
  Future<Result<Task>> setFavorite(String id, {required bool isFavorite}) {
    return _update(id, TasksTableCompanion(isFavorite: Value(isFavorite)));
  }

  /// Обновляет строку и сразу возвращает её новую версию (UPDATE … RETURNING).
  Future<Result<Task>> _update(String id, Insertable<TaskRow> changes) async {
    final result = await _guard(() async {
      final rows = await (_db.update(
        _tasks,
      )..where((task) => task.id.equals(id))).writeReturning(changes);

      return rows.firstOrNull?.toDomain();
    });

    final error = result.error;
    final task = result.data;

    if (error != null) {
      return Result.failure(error);
    }

    // Строки с таким id нет: UPDATE ничего не обновил.
    if (task == null) {
      return const Result.failure(AppFailure.notFound);
    }

    return Result.success(task);
  }

  /// Ошибки SQLite не должны ронять приложение: превращаем их в Result.
  Future<Result<T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Result.success(await action());
    } on Exception catch (error, stackTrace) {
      debugPrint('Database error: $error\n$stackTrace');
      return const Result.failure(AppFailure.storage);
    }
  }
}

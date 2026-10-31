import 'package:drift/drift.dart';
import 'package:flutter_test_app/core/database/app_database.dart';
import 'package:flutter_test_app/features/tasks/domain/entities/task.dart';

extension TaskRowMapper on TaskRow {
  Task toDomain() => Task(
    id: id,
    title: title,
    description: description,
    isCompleted: isCompleted,
    isFavorite: isFavorite,
    priority: priority,
    category: category,
    createdAt: createdAt,
  );
}

extension TaskToCompanion on Task {
  /// Companion — объект для INSERT/UPDATE: в нём можно передать
  /// только часть колонок, остальные останутся как есть.
  TasksTableCompanion toCompanion() => TasksTableCompanion.insert(
    id: id,
    title: title,
    description: Value(description),
    isCompleted: Value(isCompleted),
    isFavorite: Value(isFavorite),
    priority: priority,
    category: category,
    createdAt: createdAt,
  );
}

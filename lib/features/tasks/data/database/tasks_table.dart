import 'package:drift/drift.dart';
import 'package:flutter_test_app/features/tasks/domain/entities/task_category.dart';
import 'package:flutter_test_app/features/tasks/domain/entities/task_priority.dart';

/// Таблица `tasks`. Строка таблицы — класс TaskRow (генерирует drift),
/// чтобы не путать её с доменной моделью Task.
@DataClassName('TaskRow')
class TasksTable extends Table {
  @override
  String get tableName => 'tasks';

  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();

  // Enum хранится по имени ("high"), а не по индексу: если порядок
  // значений в enum поменяется, старые данные не сломаются.
  TextColumn get priority => textEnum<TaskPriority>()();
  TextColumn get category => textEnum<TaskCategory>()();

  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

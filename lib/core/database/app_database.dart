import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_test_app/features/recipes/data/database/liked_recipes_table.dart';
import 'package:flutter_test_app/features/settings/data/database/settings_table.dart';
import 'package:flutter_test_app/features/tasks/data/database/tasks_table.dart';
import 'package:flutter_test_app/features/tasks/data/mappers/task_row_mapper.dart';
import 'package:flutter_test_app/features/tasks/data/seed/initial_tasks.dart';
import 'package:flutter_test_app/features/tasks/domain/entities/task_category.dart';
import 'package:flutter_test_app/features/tasks/domain/entities/task_priority.dart';

part 'app_database.g.dart';

/// SQLite-база приложения (файл mini_tasks.sqlite в папке данных приложения).
@DriftDatabase(tables: [TasksTable, LikedRecipesTable, SettingsTable])
class AppDatabase extends _$AppDatabase {
  /// [executor] подменяется в тестах базой в памяти.
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'mini_tasks'));

  /// Увеличивается при каждом изменении схемы, вместе с миграцией.
  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    // Вызывается один раз, когда файла базы ещё нет.
    onCreate: (migrator) async {
      await migrator.createAll();
      await batch(
        (batch) => batch.insertAll(
          tasksTable,
          buildInitialTasks().map((task) => task.toCompanion()),
        ),
      );
    },
  );
}

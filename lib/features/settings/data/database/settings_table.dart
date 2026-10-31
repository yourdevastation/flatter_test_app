import 'package:drift/drift.dart';

/// Таблица `settings`: настройки приложения в виде «ключ — значение».
@DataClassName('SettingRow')
class SettingsTable extends Table {
  @override
  String get tableName => 'settings';

  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

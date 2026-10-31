import 'package:flutter/foundation.dart';
import 'package:flutter_test_app/core/database/app_database.dart';
import 'package:flutter_test_app/features/settings/domain/repositories/settings_repository.dart';

class DriftSettingsRepository implements SettingsRepository {
  DriftSettingsRepository(this._db);

  static const String _languageCodeKey = 'language_code';

  final AppDatabase _db;

  @override
  Future<String?> getLanguageCode() async {
    try {
      final row =
          await (_db.select(_db.settingsTable)
                ..where((setting) => setting.key.equals(_languageCodeKey)))
              .getSingleOrNull();

      return row?.value;
    } on Exception catch (error) {
      // Не смогли прочитать — просто возьмём язык системы.
      debugPrint('Database error: $error');
      return null;
    }
  }

  @override
  Future<void> saveLanguageCode(String languageCode) async {
    try {
      // INSERT … ON CONFLICT(key) DO UPDATE: вставка или замена значения.
      await _db
          .into(_db.settingsTable)
          .insertOnConflictUpdate(
            SettingsTableCompanion.insert(
              key: _languageCodeKey,
              value: languageCode,
            ),
          );
    } on Exception catch (error) {
      // Язык уже сменился в интерфейсе; не сохранится только до перезапуска.
      debugPrint('Database error: $error');
    }
  }
}

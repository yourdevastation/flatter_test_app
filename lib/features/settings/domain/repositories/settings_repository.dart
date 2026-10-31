abstract interface class SettingsRepository {
  /// Код языка, выбранного пользователем (`ru`, `en`), или null.
  Future<String?> getLanguageCode();

  Future<void> saveLanguageCode(String languageCode);
}

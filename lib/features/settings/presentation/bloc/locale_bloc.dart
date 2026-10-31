import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_app/core/l10n/l10n.dart';
import 'package:flutter_test_app/features/settings/domain/repositories/settings_repository.dart';
import 'package:flutter_test_app/features/settings/presentation/bloc/locale_event.dart';
import 'package:flutter_test_app/features/settings/presentation/bloc/locale_state.dart';

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  LocaleBloc(Locale initialLocale, this._settings)
    : super(LocaleState(currentLocale: initialLocale)) {
    on<LocaleToggled>(_onToggled);
  }

  final SettingsRepository _settings;

  /// Исходный язык приложения (шаблон app_ru.arb). supportedLocales
  /// отсортированы по алфавиту, поэтому брать supportedLocales.first нельзя.
  static const Locale fallbackLocale = Locale('ru');

  /// Язык при запуске: сохранённый пользователем, иначе язык системы,
  /// если мы его поддерживаем, иначе [fallbackLocale].
  ///
  /// В лекции здесь `Locale(Platform.localeName)`, но localeName — это
  /// строка вида "ru_RU", и Locale получал код языка "ru_RU" вместо "ru".
  static Locale resolveInitialLocale({
    required String? savedLanguageCode,
    required Locale systemLocale,
  }) {
    const supported = AppLocale.supportedLocales;

    for (final code in [savedLanguageCode, systemLocale.languageCode]) {
      for (final locale in supported) {
        if (locale.languageCode == code) {
          return locale;
        }
      }
    }

    return fallbackLocale;
  }

  Future<void> _onToggled(
    LocaleToggled event,
    Emitter<LocaleState> emit,
  ) async {
    final next = AppLocale.supportedLocales.firstWhere(
      (locale) => locale.languageCode != state.currentLocale.languageCode,
    );

    emit(state.copyWith(currentLocale: next));
    await _settings.saveLanguageCode(next.languageCode);
  }
}

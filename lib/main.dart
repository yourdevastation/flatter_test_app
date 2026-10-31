import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter_test_app/app.dart';
import 'package:flutter_test_app/core/database/app_database.dart';
import 'package:flutter_test_app/core/resources/svg_objects.dart';
import 'package:flutter_test_app/features/settings/data/repositories/drift_settings_repository.dart';
import 'package:flutter_test_app/features/settings/presentation/bloc/locale_bloc.dart';

Future<void> main() async {
  // Нужно до любых обращений к плагинам (путь к файлу БД) до runApp.
  WidgetsFlutterBinding.ensureInitialized();

  final database = AppDatabase();
  final settingsRepository = DriftSettingsRepository(database);

  // Язык читаем до первого кадра, иначе интерфейс успел бы
  // показаться на языке системы и тут же переключиться.
  final initialLocale = LocaleBloc.resolveInitialLocale(
    savedLanguageCode: await settingsRepository.getLanguageCode(),
    systemLocale: PlatformDispatcher.instance.locale,
  );

  SvgObjects.init();

  runApp(
    MiniTasksApp(
      database: database,
      settingsRepository: settingsRepository,
      initialLocale: initialLocale,
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_app/core/database/app_database.dart';
import 'package:flutter_test_app/core/l10n/l10n.dart';
import 'package:flutter_test_app/core/theme/app_theme.dart';
import 'package:flutter_test_app/features/home/home_screen.dart';
import 'package:flutter_test_app/features/recipes/data/repositories/drift_recipe_likes_repository.dart';
import 'package:flutter_test_app/features/recipes/data/repositories/remote_recipe_repository.dart';
import 'package:flutter_test_app/features/recipes/domain/repositories/recipe_likes_repository.dart';
import 'package:flutter_test_app/features/recipes/domain/repositories/recipe_repository.dart';
import 'package:flutter_test_app/features/recipes/presentation/bloc/like_bloc.dart';
import 'package:flutter_test_app/features/recipes/presentation/bloc/like_event.dart';
import 'package:flutter_test_app/features/settings/domain/repositories/settings_repository.dart';
import 'package:flutter_test_app/features/settings/presentation/bloc/locale_bloc.dart';
import 'package:flutter_test_app/features/settings/presentation/bloc/locale_state.dart';
import 'package:flutter_test_app/features/tasks/data/repositories/drift_task_repository.dart';
import 'package:flutter_test_app/features/tasks/domain/repositories/task_repository.dart';

class MiniTasksApp extends StatelessWidget {
  const MiniTasksApp({
    super.key,
    required this.database,
    required this.settingsRepository,
    required this.initialLocale,
  });

  final AppDatabase database;
  final SettingsRepository settingsRepository;
  final Locale initialLocale;

  @override
  Widget build(BuildContext context) {
    // Провайдеры над MaterialApp, чтобы репозитории и общие BLoC'и
    // были доступны и на экранах, открытых через Navigator.
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<RecipeRepository>(
          create: (_) => RemoteRecipeRepository(),
        ),
        RepositoryProvider<TaskRepository>(
          create: (_) => DriftTaskRepository(database),
        ),
        RepositoryProvider<RecipeLikesRepository>(
          create: (_) => DriftRecipeLikesRepository(database),
        ),
        RepositoryProvider<SettingsRepository>.value(value: settingsRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<LocaleBloc>(
            create: (context) =>
                LocaleBloc(initialLocale, context.read<SettingsRepository>()),
          ),
          BlocProvider<LikeBloc>(
            create: (context) =>
                LikeBloc(context.read<RecipeLikesRepository>())
                  ..add(const LikesSubscriptionRequested()),
          ),
        ],
        // При смене языка перестраивается MaterialApp, а вместе с ним
        // все строки из context.l10n.
        child: BlocBuilder<LocaleBloc, LocaleState>(
          builder: (context, state) => MaterialApp(
            onGenerateTitle: (context) => context.l10n.appTitle,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: ThemeMode.system,
            locale: state.currentLocale,
            // Наши строки + переводы стандартных виджетов Material
            // (подсказки, кнопки диалогов, формат дат).
            localizationsDelegates: AppLocale.localizationsDelegates,
            supportedLocales: AppLocale.supportedLocales,
            home: const HomeScreen(),
          ),
        ),
      ),
    );
  }
}

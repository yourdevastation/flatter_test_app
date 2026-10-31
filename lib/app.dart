import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_app/core/theme/app_theme.dart';
import 'package:flutter_test_app/features/home/home_screen.dart';
import 'package:flutter_test_app/features/recipes/data/repositories/remote_recipe_repository.dart';
import 'package:flutter_test_app/features/recipes/domain/repositories/recipe_repository.dart';

class MiniTasksApp extends StatelessWidget {
  const MiniTasksApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Провайдер над MaterialApp, чтобы репозиторий был доступен
    // и на экранах, открытых через Navigator.
    return RepositoryProvider<RecipeRepository>(
      create: (_) => RemoteRecipeRepository(),
      child: MaterialApp(
        title: 'Мини-задачи',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
      ),
    );
  }
}

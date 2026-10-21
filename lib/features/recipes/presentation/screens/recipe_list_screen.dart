import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_app/core/models/result.dart';
import 'package:flutter_test_app/core/widgets/content_card.dart';
import 'package:flutter_test_app/core/widgets/status_view.dart';
import 'package:flutter_test_app/features/recipes/domain/entities/recipe.dart';
import 'package:flutter_test_app/features/recipes/domain/repositories/recipe_repository.dart';
import 'package:flutter_test_app/features/recipes/presentation/mappers/recipe_card_mapper.dart';
import 'package:flutter_test_app/features/recipes/presentation/screens/recipe_detail_screen.dart';
import 'package:flutter_test_app/features/recipes/presentation/widgets/cooking_time_chip.dart';

class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({
    super.key,
    required this.repository,
    required this.onAddToTasks,
  });

  final RecipeRepository repository;
  final AddRecipeToTasksCallback onAddToTasks;

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  static const Duration _searchDebounce = Duration(milliseconds: 400);

  final TextEditingController _searchController = TextEditingController();
  late Future<Result<List<Recipe>>> _recipesFuture;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _recipesFuture = widget.repository.getRecipes();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _reload() {
    setState(() {
      _recipesFuture = widget.repository.getRecipes(
        query: _searchController.text,
      );
    });
  }

  // Не отправляем запрос на каждую букву: ждём, пока пользователь
  // перестанет печатать.
  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_searchDebounce, _reload);
  }

  Future<void> _onRefresh() {
    _reload();
    return _recipesFuture;
  }

  void _openDetails(Recipe recipe) {
    Navigator.of(context).push(
      CupertinoPageRoute<void>(
        builder: (context) => RecipeDetailScreen(
          recipe: recipe,
          onAddToTasks: widget.onAddToTasks,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Рецепты')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: CupertinoSearchTextField(
              controller: _searchController,
              placeholder: 'Поиск по названию',
              onChanged: _onSearchChanged,
              onSubmitted: (_) => _reload(),
            ),
          ),
          Expanded(
            child: FutureBuilder<Result<List<Recipe>>>(
              future: _recipesFuture,
              builder: (context, snapshot) {
                final result = snapshot.data;
                final isLoading =
                    snapshot.connectionState == ConnectionState.waiting;

                // При новом поиске FutureBuilder сохраняет прошлые данные,
                // поэтому полноэкранный индикатор нужен только в первый раз.
                if (result == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Column(
                  children: [
                    SizedBox(
                      height: 2,
                      child: isLoading ? const LinearProgressIndicator() : null,
                    ),
                    Expanded(child: _buildContent(result)),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(Result<List<Recipe>> result) {
    final recipes = result.data;

    if (result.isFailure || recipes == null) {
      return StatusView(
        icon: Icons.cloud_off,
        title: 'Не удалось загрузить рецепты',
        message: result.error,
        onRetry: _reload,
      );
    }

    if (recipes.isEmpty) {
      return const StatusView(
        icon: Icons.search_off,
        title: 'Ничего не найдено',
        message: 'Попробуй изменить запрос',
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          final cookingTime = recipe.cookingTimeLabel;

          return ContentCard.fromData(
            recipe.toCardData(),
            key: ValueKey(recipe.id),
            trailing: cookingTime == null
                ? null
                : CookingTimeChip(label: cookingTime),
            onTap: () => _openDetails(recipe),
          );
        },
      ),
    );
  }
}

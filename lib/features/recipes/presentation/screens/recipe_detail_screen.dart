import 'package:flutter/material.dart';
import 'package:flutter_test_app/core/extensions/date_time_extension.dart';
import 'package:flutter_test_app/core/extensions/snack_bar_extension.dart';
import 'package:flutter_test_app/core/widgets/app_bar_circle.dart';
import 'package:flutter_test_app/core/widgets/card_image.dart';
import 'package:flutter_test_app/core/widgets/info_section.dart';
import 'package:flutter_test_app/features/recipes/domain/entities/recipe.dart';
import 'package:flutter_test_app/features/recipes/presentation/mappers/recipe_card_mapper.dart';
import 'package:flutter_test_app/features/recipes/presentation/widgets/cooking_time_chip.dart';

typedef AddRecipeToTasksCallback = Future<void> Function(Recipe recipe);

class RecipeDetailScreen extends StatefulWidget {
  const RecipeDetailScreen({
    super.key,
    required this.recipe,
    required this.onAddToTasks,
  });

  final Recipe recipe;
  final AddRecipeToTasksCallback onAddToTasks;

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  bool _isAdding = false;
  bool _isAdded = false;

  Future<void> _addToTasks() async {
    setState(() {
      _isAdding = true;
    });

    await widget.onAddToTasks(widget.recipe);

    if (!mounted) {
      return;
    }

    setState(() {
      _isAdding = false;
      _isAdded = true;
    });

    context.showAppSnackBar(
      message: '«${widget.recipe.name}» добавлен в задачи',
      icon: Icons.playlist_add_check,
    );
  }

  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipe;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            stretch: true,
            leading: const AppBarCircle(child: BackButton()),
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              background: CardImage(
                url: recipe.displayImageUrl,
                heroTag: cardImageHeroTag(recipe.cardId),
              ),
            ),
          ),
          SliverToBoxAdapter(child: _RecipeDetails(recipe: recipe)),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: FilledButton.icon(
          onPressed: _isAdding || _isAdded ? null : _addToTasks,
          icon: _isAdding
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(_isAdded ? Icons.check : Icons.add_task),
          label: Text(_isAdded ? 'Добавлено в задачи' : 'Добавить в задачи'),
        ),
      ),
    );
  }
}

class _RecipeDetails extends StatelessWidget {
  const _RecipeDetails({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoryName = recipe.categoryName;
    final cookingTime = recipe.cookingTimeLabel;
    final updatedAt = recipe.updatedAt;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (categoryName != null)
                Chip(
                  avatar: const Icon(Icons.restaurant_menu, size: 18),
                  label: Text(categoryName),
                  side: BorderSide.none,
                ),
              if (cookingTime != null) CookingTimeChip(label: cookingTime),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            recipe.name,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          Text('Описание', style: theme.textTheme.titleSmall),
          const SizedBox(height: 6),
          Text(recipe.description, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 24),
          InfoSection(
            rows: [
              InfoRow(
                icon: Icons.person_outline,
                label: 'Автор',
                value: recipe.authorName ?? 'Неизвестен',
              ),
              if (cookingTime != null)
                InfoRow(
                  icon: Icons.schedule,
                  label: 'Время',
                  value: cookingTime,
                ),
              if (updatedAt != null)
                InfoRow(
                  icon: Icons.update,
                  label: 'Обновлён',
                  value:
                      '${updatedAt.toShortDate()} · '
                      '${updatedAt.toRelativeDay()}',
                ),
            ],
          ),
        ],
      ),
    );
  }
}

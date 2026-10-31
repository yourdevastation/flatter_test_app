import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_app/core/extensions/date_time_extension.dart';
import 'package:flutter_test_app/core/extensions/snack_bar_extension.dart';
import 'package:flutter_test_app/core/l10n/l10n.dart';
import 'package:flutter_test_app/core/widgets/app_bar_circle.dart';
import 'package:flutter_test_app/core/widgets/card_image.dart';
import 'package:flutter_test_app/core/widgets/info_section.dart';
import 'package:flutter_test_app/core/widgets/like_icon.dart';
import 'package:flutter_test_app/features/recipes/domain/entities/recipe.dart';
import 'package:flutter_test_app/features/recipes/presentation/bloc/like_bloc.dart';
import 'package:flutter_test_app/features/recipes/presentation/mappers/recipe_card_mapper.dart';
import 'package:flutter_test_app/features/recipes/presentation/recipe_like_actions.dart';
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
      message: context.l10n.recipeAddedToTasks(widget.recipe.name),
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
            actions: [AppBarCircle(child: _LikeButton(recipe: recipe))],
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
          label: Text(
            _isAdded ? context.l10n.addedToTasks : context.l10n.addToTasks,
          ),
        ),
      ),
    );
  }
}

class _LikeButton extends StatelessWidget {
  const _LikeButton({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    // select: кнопка перерисовывается, только когда меняется лайк
    // именно этого рецепта, а не любой из likedIds.
    final isLiked = context.select<LikeBloc, bool>(
      (bloc) => bloc.state.isLiked(recipe.id),
    );
    final l10n = context.l10n;

    return IconButton(
      tooltip: isLiked ? l10n.removeFromFavorites : l10n.addToFavorites,
      onPressed: () => setRecipeLiked(context, recipe, isLiked: !isLiked),
      icon: LikeIcon(isLiked: isLiked),
    );
  }
}

class _RecipeDetails extends StatelessWidget {
  const _RecipeDetails({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final categoryName = recipe.categoryName;
    final cookingTime = recipe.cookingTimeLabel(l10n);
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
          Text(l10n.descriptionTitle, style: theme.textTheme.titleSmall),
          const SizedBox(height: 6),
          Text(recipe.description, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 24),
          InfoSection(
            rows: [
              InfoRow(
                icon: Icons.person_outline,
                label: l10n.authorLabel,
                value: recipe.authorName ?? l10n.unknownAuthor,
              ),
              if (cookingTime != null)
                InfoRow(
                  icon: Icons.schedule,
                  label: l10n.cookingTimeLabel,
                  value: cookingTime,
                ),
              if (updatedAt != null)
                InfoRow(
                  icon: Icons.update,
                  label: l10n.updatedLabel,
                  value:
                      '${updatedAt.toShortDate(l10n)} · '
                      '${updatedAt.toRelativeDay(l10n)}',
                ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_app/core/extensions/snack_bar_extension.dart';
import 'package:flutter_test_app/core/l10n/l10n.dart';
import 'package:flutter_test_app/core/utils/debounce.dart';
import 'package:flutter_test_app/core/widgets/content_card.dart';
import 'package:flutter_test_app/core/widgets/status_view.dart';
import 'package:flutter_test_app/features/recipes/domain/entities/recipe.dart';
import 'package:flutter_test_app/features/recipes/presentation/bloc/like_bloc.dart';
import 'package:flutter_test_app/features/recipes/presentation/bloc/recipe_list_bloc.dart';
import 'package:flutter_test_app/features/recipes/presentation/bloc/recipe_list_event.dart';
import 'package:flutter_test_app/features/recipes/presentation/bloc/recipe_list_state.dart';
import 'package:flutter_test_app/features/recipes/presentation/mappers/recipe_card_mapper.dart';
import 'package:flutter_test_app/features/recipes/presentation/recipe_like_actions.dart';
import 'package:flutter_test_app/features/recipes/presentation/screens/recipe_detail_screen.dart';
import 'package:flutter_test_app/features/recipes/presentation/widgets/cooking_time_chip.dart';
import 'package:flutter_test_app/features/settings/presentation/widgets/locale_switch_button.dart';

class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({super.key, required this.onAddToTasks});

  final AddRecipeToTasksCallback onAddToTasks;

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  /// За сколько пикселей до конца списка начинать догрузку.
  static const double _loadMoreThreshold = 300;
  static const double _scrollToTopThreshold = 600;

  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final Debounce _searchDebounce = Debounce();

  /// Кнопка «наверх» перерисовывается через ValueListenableBuilder,
  /// не трогая остальной экран.
  final ValueNotifier<bool> _showScrollToTop = ValueNotifier(false);

  RecipeListBloc get _bloc => context.read<RecipeListBloc>();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchDebounce.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    _showScrollToTop.dispose();
    super.dispose();
  }

  void _onScroll() {
    final position = _scrollController.position;

    _showScrollToTop.value = position.pixels > _scrollToTopThreshold;

    // В лекции условие offset > maxScrollExtent: оно срабатывает только при
    // «пружинящей» прокрутке iOS. На Android список дальше конца не уходит,
    // поэтому догружаем заранее, за порог до конца.
    final state = _bloc.state;

    if (position.extentAfter < _loadMoreThreshold &&
        state.hasMore &&
        !state.isLoadingMore) {
      _bloc.add(const RecipeListNextPageRequested());
    }
  }

  /// Если первая страница не заполнила экран, прокручивать нечего и
  /// _onScroll не сработает, поэтому догружаем сразу.
  void _loadMoreIfNotScrollable() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) {
        return;
      }

      if (_scrollController.position.maxScrollExtent <= 0) {
        _bloc.add(const RecipeListNextPageRequested());
      }
    });
  }

  void _onSearchChanged(String query) {
    _searchDebounce.run(() => _bloc.add(RecipeListLoadRequested(query: query)));
  }

  void _onSearchSubmitted(String query) {
    _searchDebounce.cancel();
    _bloc.add(RecipeListLoadRequested(query: query));
  }

  void _reload() => _onSearchSubmitted(_searchController.text);

  Future<void> _onRefresh() {
    _searchDebounce.cancel();
    final completer = Completer<void>();

    _bloc.add(
      RecipeListRefreshRequested(
        query: _searchController.text,
        completer: completer,
      ),
    );

    return completer.future;
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
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
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tabRecipes),
        actions: const [LocaleSwitchButton()],
      ),
      floatingActionButton: ValueListenableBuilder<bool>(
        valueListenable: _showScrollToTop,
        builder: (context, isVisible, child) => AnimatedScale(
          scale: isVisible ? 1 : 0,
          duration: const Duration(milliseconds: 200),
          child: child,
        ),
        child: FloatingActionButton.small(
          // Обе вкладки в одном маршруте: у двух FAB с тегом по умолчанию
          // переход на экран деталей падает (два Hero с одним тегом).
          heroTag: null,
          tooltip: l10n.scrollToTop,
          onPressed: _scrollToTop,
          child: const Icon(Icons.arrow_upward),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: CupertinoSearchTextField(
              controller: _searchController,
              placeholder: l10n.recipesSearchHint,
              onChanged: _onSearchChanged,
              onSubmitted: _onSearchSubmitted,
            ),
          ),
          Expanded(
            child: BlocListener<RecipeListBloc, RecipeListState>(
              listenWhen: (previous, current) =>
                  previous.error != current.error,
              listener: _showErrorSnackBar,
              child: BlocConsumer<RecipeListBloc, RecipeListState>(
                listenWhen: (previous, current) =>
                    previous.recipes != current.recipes ||
                    previous.isLoadingMore != current.isLoadingMore,
                listener: (context, state) {
                  if (state.hasMore && !state.isLoading) {
                    _loadMoreIfNotScrollable();
                  }
                },
                builder: (context, state) => _buildBody(state),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, RecipeListState state) {
    final error = state.error;

    // Когда список пуст, ошибку показывает StatusView, снекбар не нужен.
    if (error != null && state.recipes.isNotEmpty) {
      context.showAppSnackBar(
        message: error.message(context.l10n),
        icon: Icons.cloud_off,
      );
    }
  }

  Widget _buildBody(RecipeListState state) {
    final l10n = context.l10n;

    if (state.recipes.isEmpty) {
      if (state.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      final error = state.error;

      if (error != null) {
        return StatusView(
          icon: Icons.cloud_off,
          title: l10n.recipesLoadError,
          message: error.message(l10n),
          onRetry: _reload,
        );
      }

      return StatusView(
        icon: Icons.search_off,
        title: l10n.recipesNotFound,
        message: l10n.recipesNotFoundHint,
      );
    }

    return Column(
      children: [
        // При новом поиске старый список остаётся на экране,
        // а сверху появляется тонкий индикатор.
        SizedBox(
          height: 2,
          child: state.isLoading ? const LinearProgressIndicator() : null,
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
              controller: _scrollController,
              // Без этого короткий список (меньше экрана) не тянется,
              // и pull-to-refresh не срабатывает.
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              // Последний элемент — подвал списка.
              itemCount: state.recipes.length + 1,
              itemBuilder: (context, index) {
                if (index == state.recipes.length) {
                  return _ListFooter(state: state);
                }

                final recipe = state.recipes[index];

                return _RecipeListItem(
                  key: ValueKey(recipe.id),
                  recipe: recipe,
                  onTap: () => _openDetails(recipe),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _RecipeListItem extends StatelessWidget {
  const _RecipeListItem({super.key, required this.recipe, required this.onTap});

  final Recipe recipe;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // В лекции весь список обёрнут в BlocBuilder<LikeBloc>, и лайк одного
    // рецепта перерисовывает все карточки. select подписывает карточку
    // только на её собственный лайк.
    final isLiked = context.select<LikeBloc, bool>(
      (bloc) => bloc.state.isLiked(recipe.id),
    );
    final cookingTime = recipe.cookingTimeLabel(context.l10n);

    return ContentCard.fromData(
      recipe.toCardData(isLiked: isLiked),
      trailing: cookingTime == null
          ? null
          : CookingTimeChip(label: cookingTime),
      onTap: onTap,
      onLike: (_, _, isLiked) =>
          setRecipeLiked(context, recipe, isLiked: isLiked),
    );
  }
}

class _ListFooter extends StatelessWidget {
  const _ListFooter({required this.state});

  final RecipeListState state;

  @override
  Widget build(BuildContext context) {
    if (state.isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.hasMore) {
      return const SizedBox(height: 56);
    }

    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        context.l10n.recipesEnd,
        textAlign: TextAlign.center,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.outline,
        ),
      ),
    );
  }
}

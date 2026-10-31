import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_app/core/extensions/snack_bar_extension.dart';
import 'package:flutter_test_app/core/utils/debounce.dart';
import 'package:flutter_test_app/core/widgets/content_card.dart';
import 'package:flutter_test_app/core/widgets/status_view.dart';
import 'package:flutter_test_app/features/recipes/domain/entities/recipe.dart';
import 'package:flutter_test_app/features/recipes/presentation/bloc/recipe_list_bloc.dart';
import 'package:flutter_test_app/features/recipes/presentation/bloc/recipe_list_event.dart';
import 'package:flutter_test_app/features/recipes/presentation/bloc/recipe_list_state.dart';
import 'package:flutter_test_app/features/recipes/presentation/mappers/recipe_card_mapper.dart';
import 'package:flutter_test_app/features/recipes/presentation/screens/recipe_detail_screen.dart';
import 'package:flutter_test_app/features/recipes/presentation/widgets/cooking_time_chip.dart';

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
    return Scaffold(
      appBar: AppBar(title: const Text('Рецепты')),
      floatingActionButton: ValueListenableBuilder<bool>(
        valueListenable: _showScrollToTop,
        builder: (context, isVisible, child) => AnimatedScale(
          scale: isVisible ? 1 : 0,
          duration: const Duration(milliseconds: 200),
          child: child,
        ),
        child: FloatingActionButton.small(
          tooltip: 'Наверх',
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
              placeholder: 'Поиск по названию',
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
      context.showAppSnackBar(message: error, icon: Icons.cloud_off);
    }
  }

  Widget _buildBody(RecipeListState state) {
    if (state.recipes.isEmpty) {
      if (state.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      final error = state.error;

      if (error != null) {
        return StatusView(
          icon: Icons.cloud_off,
          title: 'Не удалось загрузить рецепты',
          message: error,
          onRetry: _reload,
        );
      }

      return const StatusView(
        icon: Icons.search_off,
        title: 'Ничего не найдено',
        message: 'Попробуй изменить запрос',
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
          ),
        ),
      ],
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
        'Это все рецепты',
        textAlign: TextAlign.center,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.outline,
        ),
      ),
    );
  }
}

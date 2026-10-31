import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_app/features/recipes/domain/repositories/recipe_repository.dart';
import 'package:flutter_test_app/features/recipes/presentation/bloc/recipe_list_event.dart';
import 'package:flutter_test_app/features/recipes/presentation/bloc/recipe_list_state.dart';

class RecipeListBloc extends Bloc<RecipeListEvent, RecipeListState> {
  RecipeListBloc(this._repository, {this.pageSize = 3})
    : super(const RecipeListState(isLoading: true)) {
    // restartable: новый поиск отменяет обработку предыдущего, поэтому
    // поздний ответ на старый запрос не перетрёт свежий результат.
    on<RecipeListLoadRequested>(_onLoadRequested, transformer: restartable());
    // droppable: пока страница грузится, повторные запросы игнорируются.
    on<RecipeListNextPageRequested>(
      _onNextPageRequested,
      transformer: droppable(),
    );
  }

  final RecipeRepository _repository;
  final int pageSize;

  /// Номер текущей загрузки первой страницы. Догрузка запоминает его
  /// и выбрасывает свой результат, если за это время начался новый поиск.
  int _generation = 0;

  Future<void> _onLoadRequested(
    RecipeListLoadRequested event,
    Emitter<RecipeListState> emit,
  ) async {
    final generation = ++_generation;
    final isRefresh = event is RecipeListRefreshRequested;

    try {
      if (!isRefresh) {
        emit(state.copyWith(isLoading: true, error: null));
      }

      final result = await _repository.getRecipes(
        query: event.query,
        pageSize: pageSize,
      );

      if (generation != _generation) {
        return;
      }

      final page = result.data;

      if (result.isFailure || page == null) {
        final isSameQuery = event.query == state.query;

        // При обновлении того же списка старые данные оставляем,
        // а результаты другого запроса показывать нельзя.
        emit(
          state.copyWith(
            recipes: isSameQuery ? state.recipes : const [],
            nextPage: isSameQuery ? state.nextPage : null,
            query: event.query,
            isLoading: false,
            isLoadingMore: false,
            error: result.error,
          ),
        );
        return;
      }

      emit(
        RecipeListState(
          recipes: page.recipes,
          query: event.query,
          nextPage: page.nextPage,
        ),
      );
    } finally {
      if (event case RecipeListRefreshRequested(:final completer)) {
        completer.complete();
      }
    }
  }

  Future<void> _onNextPageRequested(
    RecipeListNextPageRequested event,
    Emitter<RecipeListState> emit,
  ) async {
    final nextPage = state.nextPage;

    if (nextPage == null || state.isLoading || state.isLoadingMore) {
      return;
    }

    final generation = _generation;
    emit(state.copyWith(isLoadingMore: true, error: null));

    final result = await _repository.getRecipes(
      query: state.query,
      page: nextPage,
      pageSize: pageSize,
    );

    if (generation != _generation) {
      return;
    }

    final page = result.data;

    if (result.isFailure || page == null) {
      emit(state.copyWith(isLoadingMore: false, error: result.error));
      return;
    }

    emit(
      state.copyWith(
        recipes: [...state.recipes, ...page.recipes],
        nextPage: page.nextPage,
        isLoadingMore: false,
      ),
    );
  }
}

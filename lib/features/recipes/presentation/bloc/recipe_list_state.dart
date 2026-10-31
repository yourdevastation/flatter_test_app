import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_test_app/features/recipes/domain/entities/recipe.dart';

part 'recipe_list_state.g.dart';

@CopyWith()
class RecipeListState extends Equatable {
  final List<Recipe> recipes;

  /// Запрос, по которому получены [recipes].
  final String query;

  /// null, если загружены все страницы.
  final int? nextPage;

  /// Идёт загрузка первой страницы (кроме pull-to-refresh).
  final bool isLoading;

  /// Идёт догрузка следующей страницы.
  final bool isLoadingMore;

  /// Ошибка последнего запроса.
  final String? error;

  const RecipeListState({
    this.recipes = const [],
    this.query = '',
    this.nextPage,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
  });

  bool get hasMore => nextPage != null;

  @override
  List<Object?> get props => [
    recipes,
    query,
    nextPage,
    isLoading,
    isLoadingMore,
    error,
  ];
}

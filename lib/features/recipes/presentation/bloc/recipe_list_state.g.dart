// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_list_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RecipeListStateCWProxy {
  RecipeListState recipes(List<Recipe> recipes);

  RecipeListState query(String query);

  RecipeListState nextPage(int? nextPage);

  RecipeListState isLoading(bool isLoading);

  RecipeListState isLoadingMore(bool isLoadingMore);

  RecipeListState error(AppFailure? error);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `RecipeListState(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// RecipeListState(...).copyWith(id: 12, name: "My name")
  /// ```
  RecipeListState call({
    List<Recipe> recipes,
    String query,
    int? nextPage,
    bool isLoading,
    bool isLoadingMore,
    AppFailure? error,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfRecipeListState.copyWith(...)` or call `instanceOfRecipeListState.copyWith.fieldName(value)` for a single field.
class _$RecipeListStateCWProxyImpl implements _$RecipeListStateCWProxy {
  const _$RecipeListStateCWProxyImpl(this._value);

  final RecipeListState _value;

  @override
  RecipeListState recipes(List<Recipe> recipes) => call(recipes: recipes);

  @override
  RecipeListState query(String query) => call(query: query);

  @override
  RecipeListState nextPage(int? nextPage) => call(nextPage: nextPage);

  @override
  RecipeListState isLoading(bool isLoading) => call(isLoading: isLoading);

  @override
  RecipeListState isLoadingMore(bool isLoadingMore) =>
      call(isLoadingMore: isLoadingMore);

  @override
  RecipeListState error(AppFailure? error) => call(error: error);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `RecipeListState(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// RecipeListState(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  RecipeListState call({
    Object? recipes = const $CopyWithPlaceholder(),
    Object? query = const $CopyWithPlaceholder(),
    Object? nextPage = const $CopyWithPlaceholder(),
    Object? isLoading = const $CopyWithPlaceholder(),
    Object? isLoadingMore = const $CopyWithPlaceholder(),
    Object? error = const $CopyWithPlaceholder(),
  }) {
    return RecipeListState(
      recipes: recipes == const $CopyWithPlaceholder() || recipes == null
          ? _value.recipes
          // ignore: cast_nullable_to_non_nullable
          : recipes as List<Recipe>,
      query: query == const $CopyWithPlaceholder() || query == null
          ? _value.query
          // ignore: cast_nullable_to_non_nullable
          : query as String,
      nextPage: nextPage == const $CopyWithPlaceholder()
          ? _value.nextPage
          // ignore: cast_nullable_to_non_nullable
          : nextPage as int?,
      isLoading: isLoading == const $CopyWithPlaceholder() || isLoading == null
          ? _value.isLoading
          // ignore: cast_nullable_to_non_nullable
          : isLoading as bool,
      isLoadingMore:
          isLoadingMore == const $CopyWithPlaceholder() || isLoadingMore == null
          ? _value.isLoadingMore
          // ignore: cast_nullable_to_non_nullable
          : isLoadingMore as bool,
      error: error == const $CopyWithPlaceholder()
          ? _value.error
          // ignore: cast_nullable_to_non_nullable
          : error as AppFailure?,
    );
  }
}

extension $RecipeListStateCopyWith on RecipeListState {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfRecipeListState.copyWith(...)` or `instanceOfRecipeListState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$RecipeListStateCWProxy get copyWith => _$RecipeListStateCWProxyImpl(this);
}

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test_app/core/database/app_database.dart';
import 'package:flutter_test_app/core/models/app_failure.dart';
import 'package:flutter_test_app/core/models/result.dart';
import 'package:flutter_test_app/features/recipes/domain/repositories/recipe_likes_repository.dart';

class DriftRecipeLikesRepository implements RecipeLikesRepository {
  DriftRecipeLikesRepository(this._db);

  final AppDatabase _db;

  @override
  Stream<Set<int>> watchLikedIds() {
    // watch() вместо get(): drift сам повторяет SELECT и выдаёт новый
    // результат после каждой записи в liked_recipes.
    return _db
        .select(_db.likedRecipesTable)
        .watch()
        .map((rows) => {for (final row in rows) row.recipeId});
  }

  @override
  Future<Result<void>> setLiked(int recipeId, {required bool isLiked}) async {
    final table = _db.likedRecipesTable;

    try {
      if (isLiked) {
        // INSERT OR IGNORE: повторный лайк того же рецепта не падает
        // на первичном ключе.
        await _db
            .into(table)
            .insert(
              LikedRecipesTableCompanion.insert(recipeId: Value(recipeId)),
              mode: InsertMode.insertOrIgnore,
            );
      } else {
        await (_db.delete(
          table,
        )..where((row) => row.recipeId.equals(recipeId))).go();
      }

      return const Result.success(null);
    } on Exception catch (error, stackTrace) {
      debugPrint('Database error: $error\n$stackTrace');
      return const Result.failure(AppFailure.storage);
    }
  }
}

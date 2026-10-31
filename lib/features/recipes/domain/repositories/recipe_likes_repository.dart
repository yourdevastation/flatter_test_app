import 'package:flutter_test_app/core/models/result.dart';

abstract interface class RecipeLikesRepository {
  /// id лайкнутых рецептов. Поток выдаёт новое значение при каждом
  /// изменении таблицы, поэтому подписчикам не нужно перечитывать данные.
  Stream<Set<int>> watchLikedIds();

  Future<Result<void>> setLiked(int recipeId, {required bool isLiked});
}

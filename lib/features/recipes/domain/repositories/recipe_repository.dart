import 'package:flutter_test_app/core/models/result.dart';
import 'package:flutter_test_app/features/recipes/domain/entities/recipe.dart';

abstract interface class RecipeRepository {
  Future<Result<List<Recipe>>> getRecipes({String? query});
}

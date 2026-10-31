import 'package:flutter_test_app/core/models/result.dart';
import 'package:flutter_test_app/features/recipes/domain/entities/recipe_page.dart';

abstract interface class RecipeRepository {
  Future<Result<RecipePage>> getRecipes({
    String? query,
    int page = 1,
    int pageSize = 10,
  });
}

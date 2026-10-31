import 'package:flutter_test_app/features/recipes/domain/entities/recipe.dart';

class RecipePage {
  final List<Recipe> recipes;

  /// null, если это последняя страница.
  final int? nextPage;

  const RecipePage({required this.recipes, this.nextPage});
}

import 'package:drift/drift.dart';

/// Таблица `liked_recipes`: id рецептов с сервера, которые лайкнул
/// пользователь. Аналог списка likedIds в SharedPreferences из лекции.
@DataClassName('LikedRecipeRow')
class LikedRecipesTable extends Table {
  @override
  String get tableName => 'liked_recipes';

  IntColumn get recipeId => integer()();
  DateTimeColumn get likedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {recipeId};
}

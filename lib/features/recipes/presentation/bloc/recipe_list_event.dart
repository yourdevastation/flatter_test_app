import 'dart:async';

sealed class RecipeListEvent {
  const RecipeListEvent();
}

/// Загрузить первую страницу: при открытии экрана, поиске и «Повторить».
class RecipeListLoadRequested extends RecipeListEvent {
  const RecipeListLoadRequested({this.query = ''});

  final String query;
}

/// Pull-to-refresh. Это та же загрузка первой страницы, поэтому событие
/// наследуется от [RecipeListLoadRequested] и попадает в тот же обработчик.
/// [completer] завершается, когда данные получены: до этого крутится
/// индикатор RefreshIndicator.
class RecipeListRefreshRequested extends RecipeListLoadRequested {
  const RecipeListRefreshRequested({super.query, required this.completer});

  final Completer<void> completer;
}

/// Догрузить следующую страницу при прокрутке к концу списка.
class RecipeListNextPageRequested extends RecipeListEvent {
  const RecipeListNextPageRequested();
}

sealed class LikeEvent {
  const LikeEvent();
}

/// Подписаться на лайки из БД (аналог LoadLikesEvent из лекции).
class LikesSubscriptionRequested extends LikeEvent {
  const LikesSubscriptionRequested();
}

/// Поставить или снять лайк (аналог ChangeLikeEvent из лекции).
/// Передаём не «переключить», а итоговое значение: так повторное
/// событие ничего не ломает, а «Отменить» в снекбаре — это то же событие
/// с противоположным значением.
class RecipeLikeChanged extends LikeEvent {
  const RecipeLikeChanged(this.recipeId, {required this.isLiked});

  final int recipeId;
  final bool isLiked;
}

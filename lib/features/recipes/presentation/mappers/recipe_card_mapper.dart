import 'package:flutter/material.dart';
import 'package:flutter_test_app/core/widgets/content_card_data.dart';
import 'package:flutter_test_app/features/recipes/domain/entities/recipe.dart';

/// Показывается, если у рецепта нет картинки.
const _placeholderImageUrl =
    'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800&q=70&auto=format&fit=crop';

extension RecipeCardMapper on Recipe {
  /// Префикс не даёт id рецептов пересечься с id задач в Hero-тегах.
  String get cardId => 'recipe_$id';

  String get displayImageUrl => imageUrl ?? _placeholderImageUrl;

  String? get cookingTimeLabel {
    return switch ((cookingTimeFrom, cookingTimeTo)) {
      (final int from, final int to) when from < 60 && to < 60 && from != to =>
        '$from–$to мин',
      (final int from, final int to)
          when from % 60 == 0 && to % 60 == 0 && from != to =>
        '${from ~/ 60}–${to ~/ 60} ч',
      (final int from, final int to) when from != to =>
        '${_formatMinutes(from)} – ${_formatMinutes(to)}',
      (final int from, _) => _formatMinutes(from),
      (_, final int to) => _formatMinutes(to),
      _ => null,
    };
  }

  ContentCardData toCardData() => ContentCardData(
    id: cardId,
    title: name,
    imageUrl: displayImageUrl,
    icon: Icons.restaurant_menu,
    caption: categoryName,
    description: description,
  );
}

String _formatMinutes(int minutes) {
  final hours = minutes ~/ 60;
  final rest = minutes % 60;

  return switch ((hours, rest)) {
    (0, _) => '$rest мин',
    (_, 0) => '$hours ч',
    _ => '$hours ч $rest мин',
  };
}

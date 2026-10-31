import 'package:flutter/material.dart';
import 'package:flutter_test_app/core/l10n/l10n.dart';
import 'package:flutter_test_app/core/widgets/content_card_data.dart';
import 'package:flutter_test_app/features/recipes/domain/entities/recipe.dart';

/// Показывается, если у рецепта нет картинки.
const _placeholderImageUrl =
    'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800&q=70&auto=format&fit=crop';

extension RecipeCardMapper on Recipe {
  /// Префикс не даёт id рецептов пересечься с id задач в Hero-тегах.
  String get cardId => 'recipe_$id';

  String get displayImageUrl => imageUrl ?? _placeholderImageUrl;

  String? cookingTimeLabel(AppLocale l10n) {
    return switch ((cookingTimeFrom, cookingTimeTo)) {
      (final int from, final int to) when from < 60 && to < 60 && from != to =>
        l10n.minutesRangeShort(from, to),
      (final int from, final int to)
          when from % 60 == 0 && to % 60 == 0 && from != to =>
        l10n.hoursRangeShort(from ~/ 60, to ~/ 60),
      (final int from, final int to) when from != to =>
        '${_formatMinutes(from, l10n)} – ${_formatMinutes(to, l10n)}',
      (final int from, _) => _formatMinutes(from, l10n),
      (_, final int to) => _formatMinutes(to, l10n),
      _ => null,
    };
  }

  ContentCardData toCardData({required bool isLiked}) => ContentCardData(
    id: cardId,
    title: name,
    imageUrl: displayImageUrl,
    icon: Icons.restaurant_menu,
    caption: categoryName,
    description: description,
    isLiked: isLiked,
  );
}

String _formatMinutes(int minutes, AppLocale l10n) {
  final hours = minutes ~/ 60;
  final rest = minutes % 60;

  return switch ((hours, rest)) {
    (0, _) => l10n.minutesShort(rest),
    (_, 0) => l10n.hoursShort(hours),
    _ => l10n.hoursMinutesShort(hours, rest),
  };
}

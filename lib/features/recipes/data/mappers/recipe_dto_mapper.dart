import 'package:flutter_test_app/core/extensions/string_extension.dart';
import 'package:flutter_test_app/features/recipes/data/dto/author_dto.dart';
import 'package:flutter_test_app/features/recipes/data/dto/recipe_dto.dart';
import 'package:flutter_test_app/features/recipes/domain/entities/recipe.dart';

extension RecipeDtoMapper on RecipeDto {
  /// [baseUri] нужен, потому что сервер отдаёт картинки относительными путями
  /// вида "./images/borsch.png".
  Recipe toDomain({required Uri baseUri}) => Recipe(
    id: id ?? 0,
    name: name ?? 'Без названия',
    description: description ?? '',
    imageUrl: _resolveImageUrl(baseUri),
    cookingTimeFrom: cookingTimeFrom,
    cookingTimeTo: cookingTimeTo,
    authorName: author?.fullName,
    categoryName: category?.name,
    updatedAt: _parseDate(updatedAt),
  );

  String? _resolveImageUrl(Uri baseUri) {
    final imageUrl = this.imageUrl;

    if (imageUrl == null || imageUrl.isBlank) {
      return null;
    }

    return baseUri.resolve(imageUrl).toString();
  }
}

extension on AuthorDto {
  String? get fullName {
    final name = [firstName, lastName].nonNulls.join(' ');

    return name.isBlank ? null : name;
  }
}

/// Разбирает дату формата "dd.MM.yyyy".
DateTime? _parseDate(String? value) {
  final parts = value?.split('.').map(int.tryParse).toList();

  if (parts case [final int day, final int month, final int year]) {
    return DateTime(year, month, day);
  }

  return null;
}

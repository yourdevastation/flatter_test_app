import 'package:flutter_test_app/features/recipes/data/dto/author_dto.dart';
import 'package:flutter_test_app/features/recipes/data/dto/category_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recipe_dto.g.dart';

@JsonSerializable(createToJson: false)
class RecipeDto {
  final int? id;
  final String? name;
  final String? description;
  final String? imageUrl;
  final int? cookingTimeFrom;
  final int? cookingTimeTo;

  // На сервере поле называется dateLastModified и приходит как "dd.MM.yyyy".
  @JsonKey(name: 'dateLastModified')
  final String? updatedAt;

  final AuthorDto? author;
  final CategoryDto? category;

  const RecipeDto({
    this.id,
    this.name,
    this.description,
    this.imageUrl,
    this.cookingTimeFrom,
    this.cookingTimeTo,
    this.updatedAt,
    this.author,
    this.category,
  });

  factory RecipeDto.fromJson(Map<String, dynamic> json) =>
      _$RecipeDtoFromJson(json);
}

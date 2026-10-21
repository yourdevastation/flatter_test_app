// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecipeDto _$RecipeDtoFromJson(Map<String, dynamic> json) => RecipeDto(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  description: json['description'] as String?,
  imageUrl: json['imageUrl'] as String?,
  cookingTimeFrom: (json['cookingTimeFrom'] as num?)?.toInt(),
  cookingTimeTo: (json['cookingTimeTo'] as num?)?.toInt(),
  updatedAt: json['dateLastModified'] as String?,
  author: json['author'] == null
      ? null
      : AuthorDto.fromJson(json['author'] as Map<String, dynamic>),
  category: json['category'] == null
      ? null
      : CategoryDto.fromJson(json['category'] as Map<String, dynamic>),
);

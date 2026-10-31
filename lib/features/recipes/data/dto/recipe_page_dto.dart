import 'package:flutter_test_app/features/recipes/data/dto/recipe_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recipe_page_dto.g.dart';

/// Ответ `GET /recipe?page=...`: `{ data: [...], meta: { pagination: {...} } }`.
@JsonSerializable(createToJson: false)
class RecipePageDto {
  final List<RecipeDto>? data;
  final PageMetaDto? meta;

  const RecipePageDto({this.data, this.meta});

  factory RecipePageDto.fromJson(Map<String, dynamic> json) =>
      _$RecipePageDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class PageMetaDto {
  final PaginationDto? pagination;

  const PageMetaDto({this.pagination});

  factory PageMetaDto.fromJson(Map<String, dynamic> json) =>
      _$PageMetaDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class PaginationDto {
  final int? current;
  final int? next;
  final int? last;
  final int? total;

  const PaginationDto({this.current, this.next, this.last, this.total});

  factory PaginationDto.fromJson(Map<String, dynamic> json) =>
      _$PaginationDtoFromJson(json);
}

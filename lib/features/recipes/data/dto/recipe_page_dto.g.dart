// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_page_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecipePageDto _$RecipePageDtoFromJson(Map<String, dynamic> json) =>
    RecipePageDto(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => RecipeDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: json['meta'] == null
          ? null
          : PageMetaDto.fromJson(json['meta'] as Map<String, dynamic>),
    );

PageMetaDto _$PageMetaDtoFromJson(Map<String, dynamic> json) => PageMetaDto(
  pagination: json['pagination'] == null
      ? null
      : PaginationDto.fromJson(json['pagination'] as Map<String, dynamic>),
);

PaginationDto _$PaginationDtoFromJson(Map<String, dynamic> json) =>
    PaginationDto(
      current: (json['current'] as num?)?.toInt(),
      next: (json['next'] as num?)?.toInt(),
      last: (json['last'] as num?)?.toInt(),
      total: (json['total'] as num?)?.toInt(),
    );

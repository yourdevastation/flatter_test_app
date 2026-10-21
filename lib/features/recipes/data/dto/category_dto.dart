import 'package:json_annotation/json_annotation.dart';

part 'category_dto.g.dart';

@JsonSerializable(createToJson: false)
class CategoryDto {
  final int? id;
  final String? name;

  const CategoryDto({this.id, this.name});

  factory CategoryDto.fromJson(Map<String, dynamic> json) =>
      _$CategoryDtoFromJson(json);
}

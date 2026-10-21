import 'package:json_annotation/json_annotation.dart';

part 'author_dto.g.dart';

@JsonSerializable(createToJson: false)
class AuthorDto {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? email;

  const AuthorDto({this.id, this.firstName, this.lastName, this.email});

  factory AuthorDto.fromJson(Map<String, dynamic> json) =>
      _$AuthorDtoFromJson(json);
}

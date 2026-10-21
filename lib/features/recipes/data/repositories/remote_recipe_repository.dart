import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test_app/core/extensions/string_extension.dart';
import 'package:flutter_test_app/core/models/result.dart';
import 'package:flutter_test_app/core/network/api_config.dart';
import 'package:flutter_test_app/features/recipes/data/dto/recipe_dto.dart';
import 'package:flutter_test_app/features/recipes/data/mappers/recipe_dto_mapper.dart';
import 'package:flutter_test_app/features/recipes/domain/entities/recipe.dart';
import 'package:flutter_test_app/features/recipes/domain/repositories/recipe_repository.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class RemoteRecipeRepository implements RecipeRepository {
  RemoteRecipeRepository({Dio? dio}) : _dio = dio ?? _createDio();

  final Dio _dio;

  static final Uri _baseUri = Uri.parse(ApiConfig.baseUrl);

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: '${ApiConfig.baseUrl}${ApiConfig.apiPath}',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(requestHeader: true, requestBody: true),
      );
    }

    return dio;
  }

  @override
  Future<Result<List<Recipe>>> getRecipes({String? query}) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        '/recipe',
        queryParameters: {
          if (query != null && query.isNotBlank) 'name': query.trimmed(),
        },
      );

      final recipes = (response.data ?? [])
          .map(
            (json) =>
                RecipeDto.fromJson(json as Map<String, dynamic>)
                    .toDomain(baseUri: _baseUri),
          )
          .toList();

      return Result.success(recipes);
    } on DioException catch (error) {
      return Result.failure(_describeError(error));
    }
  }

  String _describeError(DioException error) {
    return switch (error.type) {
      DioExceptionType.connectionTimeout || DioExceptionType.connectionError =>
        'Сервер недоступен. Проверь, что бэкенд запущен.',
      DioExceptionType.receiveTimeout => 'Сервер слишком долго отвечает.',
      DioExceptionType.badResponse =>
        'Сервер ответил ошибкой ${error.response?.statusCode}.',
      _ => 'Не удалось загрузить рецепты.',
    };
  }
}

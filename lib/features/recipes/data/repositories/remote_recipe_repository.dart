import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test_app/core/extensions/string_extension.dart';
import 'package:flutter_test_app/core/models/app_failure.dart';
import 'package:flutter_test_app/core/models/result.dart';
import 'package:flutter_test_app/core/network/api_config.dart';
import 'package:flutter_test_app/features/recipes/data/dto/recipe_page_dto.dart';
import 'package:flutter_test_app/features/recipes/data/mappers/recipe_dto_mapper.dart';
import 'package:flutter_test_app/features/recipes/domain/entities/recipe_page.dart';
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
  Future<Result<RecipePage>> getRecipes({
    String? query,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/recipe',
        queryParameters: {
          if (query != null && query.isNotBlank) 'name': query.trimmed(),
          'page': page,
          'size': pageSize,
        },
      );

      final dto = RecipePageDto.fromJson(response.data ?? const {});

      return Result.success(dto.toDomain(baseUri: _baseUri));
    } on DioException catch (error) {
      return Result.failure(_mapError(error));
    }
  }

  AppFailure _mapError(DioException error) {
    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.connectionError => AppFailure.connection,
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => AppFailure.timeout,
      DioExceptionType.badResponse => AppFailure.server,
      _ => AppFailure.unknown,
    };
  }
}

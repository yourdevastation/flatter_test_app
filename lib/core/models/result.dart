import 'package:flutter_test_app/core/models/app_failure.dart';

class Result<T> {
  final T? data;
  final AppFailure? error;

  const Result.success(this.data) : error = null;
  const Result.failure(AppFailure this.error) : data = null;

  bool get isSuccess => error == null;
  bool get isFailure => !isSuccess;
}

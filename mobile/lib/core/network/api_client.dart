import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:mobile/core/errors/failures.dart';

mixin ApiClientBase {
  Dio get dio;

  Failure _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return const NetworkFailure('Connection timeout');
    }
    if (e.response != null) {
      return ServerFailure(e.response?.data['message'] ?? 'Server error');
    }
    return const NetworkFailure('No internet connection');
  }
}

mixin GetApiClient on ApiClientBase {
  Future<Either<Failure, Response>> get(
    String path, {
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      return Right(await dio.get(path, queryParameters: queryParams));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    }
  }
}

mixin PostApiClient on ApiClientBase {
  Future<Either<Failure, Response>> post(String path, {dynamic data}) async {
    try {
      return Right(await dio.post(path, data: data));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    }
  }
}

mixin PutApiClient on ApiClientBase {
  Future<Either<Failure, Response>> put(String path, {dynamic data}) async {
    try {
      return Right(await dio.put(path, data: data));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    }
  }
}

mixin DeleteApiClient on ApiClientBase {
  Future<Either<Failure, Response>> delete(String path) async {
    try {
      return Right(await dio.delete(path));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    }
  }
}

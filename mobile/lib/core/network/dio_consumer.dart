import 'package:dio/dio.dart';

import '../errors/exception.dart';
import 'api_consumer.dart';

class DioConsumer implements ApiConsumer {
  DioConsumer({required this.dio});

  final Dio dio;

  @override
  Future<T> get<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.get<T>(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return response.data as T;
    } on DioException catch (error) {
      handleDioException(error);
      rethrow;
    }
  }

  @override
  Future<T> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = false,
  }) async {
    try {
      final response = await dio.post<T>(
        path,
        data: _requestData(data, isFormData),
        queryParameters: queryParameters,
      );
      return response.data as T;
    } on DioException catch (error) {
      handleDioException(error);
      rethrow;
    }
  }

  @override
  Future<T> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = false,
  }) async {
    try {
      final response = await dio.patch<T>(
        path,
        data: _requestData(data, isFormData),
        queryParameters: queryParameters,
      );
      return response.data as T;
    } on DioException catch (error) {
      handleDioException(error);
      rethrow;
    }
  }

  @override
  Future<T> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return response.data as T;
    } on DioException catch (error) {
      handleDioException(error);
      rethrow;
    }
  }

  Object? _requestData(Object? data, bool isFormData) {
    if (!isFormData) {
      return data;
    }

    if (data is! Map<String, dynamic>) {
      throw ArgumentError.value(
        data,
        'data',
        'Form data must be a Map<String, dynamic>',
      );
    }

    return FormData.fromMap(data);
  }
}

import 'package:dio/dio.dart';
import 'package:mobile/core/errors/dio_exception_handler.dart';
import 'package:mobile/core/network/api_client.dart';

class ApiClientImpl implements ApiClient {
  final Dio dio;
  ApiClientImpl(this.dio);
  @override
  Future<Response> get(String path, {Map<String, dynamic>? queryParams}) async {
    try {
      return await dio.get(path, queryParameters: queryParams);
    } on DioException catch (e) {
      throw (e.handleDioExceptionError());
    }
  }

  @override
  Future<dynamic> patch(
    String path, {
    data,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      return await dio.patch(path, data: data, queryParameters: queryParams);
    } on DioException catch (e) {
      throw (e.handleDioExceptionError());
    }
  }

  @override
  Future<dynamic> post(
    String path, {
    data,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      return await dio.post(path, data: data, queryParameters: queryParams);
    } on DioException catch (e) {
      print('Status: ${e.response?.statusCode}');
      print('Requested URL: ${e.requestOptions.uri}');
      print('Redirect location: ${e.response?.headers.value('location')}');
      print('Response headers: ${e.response?.headers}');
      print('Response body: ${e.response?.data}');
      throw (e.handleDioExceptionError());
    }
  }

  @override
  Future<dynamic> put(
    String path, {
    data,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      return await dio.put(path, data: data, queryParameters: queryParams);
    } on DioException catch (e) {
      throw (e.handleDioExceptionError());
    }
  }
}

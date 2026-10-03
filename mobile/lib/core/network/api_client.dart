import 'package:dio/dio.dart';
import 'package:mobile/core/errors/dio_exception_handler.dart';
mixin ApiClientBase {
  Dio get dio;
}

mixin GetApiClient on ApiClientBase {
  Future<Response> get(String path, {Map<String, dynamic>? queryParams}) async {
    try {
      return await dio.get(path, queryParameters: queryParams);
    } on DioException catch (e) {
      throw e.extractServerException();
    }
  }
}

mixin PostApiClient on ApiClientBase {
  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await dio.post(path, data: data);
    } on DioException catch (e) {
      throw e.extractServerException();
    }
  }
}

mixin PutApiClient on ApiClientBase {
  Future<Response> put(String path, {dynamic data}) async {
    try {
      return await dio.put(path, data: data);
    } on DioException catch (e) {
      throw e.extractServerException();
    }
  }
}

mixin DeleteApiClient on ApiClientBase {
  Future<Response> delete(String path) async {
    try {
      return await dio.delete(path);
    } on DioException catch (e) {
      throw e.extractServerException();
    }
  }
}

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/errors/exception.dart';
import 'package:mobile/core/network/api_client.dart';
import 'package:mobile/core/network/api_client_impl.dart';
import 'package:mobile/core/utils/constants/endpoints.dart';
import 'package:mocktail/mocktail.dart';

class DioMock extends Mock implements Dio {}

void main() {
  late DioMock dioMock;
  late ApiClient apiClientImpl;

  setUp(() {
    dioMock = DioMock();
    apiClientImpl = ApiClientImpl(dioMock);
  });
  group("Testing the outputs of get method", () {
    test("Testing the method if it returned successfully", () async {
      final Response tResponse = Response(
        requestOptions: RequestOptions(path: '/test'),
        statusCode: 200,
        data: {'email': 'jfosdijfo', 'username': 'ali'},
      );
      Map<String, dynamic> query = {'Content-Type': 'application/json'};
      when(
        () => dioMock.get(
          ApiEndpoints.baseUrl + ApiEndpoints.register,
          queryParameters: query,
        ),
      ).thenAnswer((_) async => tResponse);

      final result = await apiClientImpl.get(
        ApiEndpoints.baseUrl + ApiEndpoints.register,
        queryParams: query,
      );

      expect(result, tResponse);
      verify(
        () => dioMock.get(
          ApiEndpoints.baseUrl + ApiEndpoints.register,
          queryParameters: query,
        ),
      ).called(1);
    });
    test("Testing the method if it returned with excpetion", () async {
      final DioException exception = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 400,
          data: {'error': 'bad response'},
        ),
      );
      Map<String, dynamic> query = {'Content-Type': 'application/json'};
      when(
        () => dioMock.get(
          ApiEndpoints.baseUrl + ApiEndpoints.register,
          queryParameters: query,
        ),
      ).thenThrow(exception);

      expect(
        () async => await apiClientImpl.get(
          ApiEndpoints.baseUrl + ApiEndpoints.register,
          queryParams: query,
        ),
        throwsA(isA<ServerException>()),
      );
      verify(
        () => dioMock.get(
          ApiEndpoints.baseUrl + ApiEndpoints.register,
          queryParameters: query,
        ),
      ).called(1);
    });
  });
  group("Testing the outputs of post method", () {
    test("Testing the method if it returned successfully", () async {
      final Response tResponse = Response(
        requestOptions: RequestOptions(path: '/test'),
        statusCode: 200,
        data: {'email': 'jfosdijfo', 'username': 'ali'},
      );
      Map<String, dynamic> query = {
        'Content-Type': 'application/json',
        'Authorization': 'fosidjfodijfodsifj',
      };
      Map<String, dynamic> data = {'productName': 'shirt', 'price': '12 EGP'};
      when(
        () => dioMock.post(
          ApiEndpoints.baseUrl + ApiEndpoints.register,
          data: data,
          queryParameters: query,
        ),
      ).thenAnswer((_) async => tResponse);

      final result = await apiClientImpl.post(
        ApiEndpoints.baseUrl + ApiEndpoints.register,
        data: data,
        queryParams: query,
      );

      expect(result, tResponse);
      verify(
        () => dioMock.post(
          ApiEndpoints.baseUrl + ApiEndpoints.register,
          data: data,
          queryParameters: query,
        ),
      ).called(1);
    });
    test("Testing the method if it returned with excpetion", () async {
      final DioException exception = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 400,
          data: {'error': 'bad response'},
        ),
      );
      Map<String, dynamic> query = {
        'Content-Type': 'application/json',
        'Authorization': 'fosidjfodijfodsifj',
      };
      Map<String, dynamic> data = {'productName': 'shirt', 'price': '12 EGP'};
      when(
        () => dioMock.post(
          ApiEndpoints.baseUrl + ApiEndpoints.register,
          data: data,
          queryParameters: query,
        ),
      ).thenThrow(exception);
      expect(
        () async => await apiClientImpl.post(
          ApiEndpoints.baseUrl + ApiEndpoints.register,
          data: data,
          queryParams: query,
        ),
        throwsA(isA<ServerException>()),
      );
      verify(
        () => dioMock.post(
          ApiEndpoints.baseUrl + ApiEndpoints.register,
          data: data,
          queryParameters: query,
        ),
      ).called(1);
    });
  });
  group("Testing the outputs of put method", () {
    test("Testing the method if it returned successfully", () async {
      final Response tResponse = Response(
        requestOptions: RequestOptions(path: '/test'),
        statusCode: 200,
        data: {'email': 'jfosdijfo', 'username': 'ali'},
      );
      Map<String, dynamic> query = {
        'Content-Type': 'application/json',
        'Authorization': 'fosidjfodijfodsifj',
      };
      Map<String, dynamic> data = {'productName': 'shirt', 'price': '12 EGP'};
      when(
        () => dioMock.put(
          ApiEndpoints.baseUrl + ApiEndpoints.register,
          data: data,
          queryParameters: query,
        ),
      ).thenAnswer((_) async => tResponse);

      final result = await apiClientImpl.put(
        ApiEndpoints.baseUrl + ApiEndpoints.register,
        data: data,
        queryParams: query,
      );

      expect(result, tResponse);
      verify(
        () => dioMock.put(
          ApiEndpoints.baseUrl + ApiEndpoints.register,
          data: data,
          queryParameters: query,
        ),
      ).called(1);
    });
    test("Testing the method if it returned with excpetion", () async {
      final DioException exception = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 400,
          data: {'error': 'bad response'},
        ),
      );
      Map<String, dynamic> query = {
        'Content-Type': 'application/json',
        'Authorization': 'fosidjfodijfodsifj',
      };
      Map<String, dynamic> data = {'productName': 'shirt', 'price': '12 EGP'};
      when(
        () => dioMock.put(
          ApiEndpoints.baseUrl + ApiEndpoints.register,
          data: data,
          queryParameters: query,
        ),
      ).thenThrow(exception);
      expect(
        () async => await apiClientImpl.put(
          ApiEndpoints.baseUrl + ApiEndpoints.register,
          data: data,
          queryParams: query,
        ),
        throwsA(isA<ServerException>()),
      );
      verify(
        () => dioMock.put(
          ApiEndpoints.baseUrl + ApiEndpoints.register,
          data: data,
          queryParameters: query,
        ),
      ).called(1);
    });
  });
  group("Testing the outputs of patch method", () {
    test("Testing the method if it returned successfully", () async {
      final Response tResponse = Response(
        requestOptions: RequestOptions(path: '/test'),
        statusCode: 200,
        data: {'email': 'jfosdijfo', 'username': 'ali'},
      );
      Map<String, dynamic> query = {
        'Content-Type': 'application/json',
        'Authorization': 'fosidjfodijfodsifj',
      };
      Map<String, dynamic> data = {'productName': 'shirt', 'price': '12 EGP'};
      when(
        () => dioMock.patch(
          ApiEndpoints.baseUrl + ApiEndpoints.register,
          data: data,
          queryParameters: query,
        ),
      ).thenAnswer((_) async => tResponse);

      final result = await apiClientImpl.patch(
        ApiEndpoints.baseUrl + ApiEndpoints.register,
        data: data,
        queryParams: query,
      );

      expect(result, tResponse);
      verify(
        () => dioMock.patch(
          ApiEndpoints.baseUrl + ApiEndpoints.register,
          data: data,
          queryParameters: query,
        ),
      ).called(1);
    });
    test("Testing the method if it returned with excpetion", () async {
      final DioException exception = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 400,
          data: {'error': 'bad response'},
        ),
      );
      Map<String, dynamic> query = {
        'Content-Type': 'application/json',
        'Authorization': 'fosidjfodijfodsifj',
      };
      Map<String, dynamic> data = {'productName': 'shirt', 'price': '12 EGP'};
      when(
        () => dioMock.patch(
          ApiEndpoints.baseUrl + ApiEndpoints.register,
          data: data,
          queryParameters: query,
        ),
      ).thenThrow(exception);
      expect(
        () async => await apiClientImpl.patch(
          ApiEndpoints.baseUrl + ApiEndpoints.register,
          data: data,
          queryParams: query,
        ),
        throwsA(isA<ServerException>()),
      );
      verify(
        () => dioMock.patch(
          ApiEndpoints.baseUrl + ApiEndpoints.register,
          data: data,
          queryParameters: query,
        ),
      ).called(1);
    });
  });
}

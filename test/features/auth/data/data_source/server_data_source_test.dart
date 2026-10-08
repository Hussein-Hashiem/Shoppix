import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/errors/exception.dart';
import 'package:mobile/core/network/api_client.dart';
import 'package:mobile/core/utils/constants/endpoints.dart';
import 'package:mobile/features/auth/data/data_source/server_datasource.dart';
import 'package:mobile/features/auth/data/models/register_model.dart';
import 'package:mocktail/mocktail.dart';

class ApiClientMock extends Mock implements ApiClient {}

void main() {
  late ApiClientMock apiClientMock;
  late ServerDatasource serverDatasource;
  setUp(() {
    apiClientMock = ApiClientMock();
    serverDatasource = ServerDatasource(apiClient: apiClientMock);
  });
  group('testing the outputs of the register register method', () {
    final Map<String, dynamic> data = {
      'email': 'alimohamed@gmail.com',
      'name': 'ali',
      'password': '12345678ji',
    };
    // query parameters
    final Map<String, dynamic> query = {'Content-Type': 'application/json'};
    test(
      "check if the method returns Register Model when successful",
      () async {
        final RegisterModel expectedModel = RegisterModel(
          email: 'alimohamed@gmail.com',
          name: 'ali',
          userId: 'jofsidjfosdijf',
        );
        when(
          () => apiClientMock.post(
            ApiEndpoints.baseUrl + ApiEndpoints.register,
            data: data,
            queryParams: query,
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/test'),
            data: {
              'email': 'alimohamed@gmail.com',
              'name': 'ali',
              'userId': 'jofsidjfosdijf',
            },
          ),
        );

        final result = await serverDatasource.register(
          email: 'alimohamed@gmail.com',
          name: 'ali',
          password: '12345678ji',
        );

        expect(result, expectedModel);
        verify(
          () => apiClientMock.post(
            ApiEndpoints.baseUrl + ApiEndpoints.register,
            data: data,
            queryParams: query,
          ),
        ).called(1);
      },
    );
    test("check if the method returns the correct ServerException when there is an error", () {
      when(
        () => apiClientMock.post(
          ApiEndpoints.baseUrl + ApiEndpoints.register,
          data: data,
          queryParams: query,
        ),
      ).thenThrow(ServerException(message: 'Not Found', statusCode: 404));

      expect(
        serverDatasource.register(
          email: 'alimohamed@gmail.com',
          name: 'ali',
          password: '12345678ji',
        ),
        throwsA(
          isA<ServerException>()
              .having((e) => e.message, 'test', 'Not Found')
              .having((e) => e.statusCode, 'test', 404),
        ),
      );
      verify(
        () => apiClientMock.post(
          ApiEndpoints.baseUrl + ApiEndpoints.register,
          data: data,
          queryParams: query,
        ),
      ).called(1);
    });
  });
  group('testing the outputs of the login method', () {
    final Map<String, dynamic> data = {
      'email': 'alimohamed@gmail.com',
      'password': '12345678ji',
    };
    // query parameters
    final Map<String, dynamic> query = {'Content-Type': 'application/json'};
    test("check if the method calls the post method when successful", () async {
      when(
        () => apiClientMock.post(
          ApiEndpoints.baseUrl + ApiEndpoints.login,
          data: data,
          queryParams: query,
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/test'),
          // here, empty map is <dynaimc, dynamic> by default, so we need to instantiate the map with types directly
          // without as key word
          data: <String, dynamic>{},
        ),
      );

      final Map<String, dynamic> result = await serverDatasource.login(
        email: 'alimohamed@gmail.com',
        password: '12345678ji',
      );

      expect(result, <String, dynamic>{});
      verify(
        () => apiClientMock.post(
          ApiEndpoints.baseUrl + ApiEndpoints.login,
          data: data,
          queryParams: query,
        ),
      ).called(1);
    });
    test("check if the method returns the correct ServerException when there is an error", () {
      when(
        () => apiClientMock.post(
          ApiEndpoints.baseUrl + ApiEndpoints.login,
          data: data,
          queryParams: query,
        ),
      ).thenThrow(ServerException(message: 'Not Found', statusCode: 404));

      expect(
        serverDatasource.login(
          email: 'alimohamed@gmail.com',
          password: '12345678ji',
        ),
        throwsA(
          isA<ServerException>()
              .having((e) => e.message, 'test', 'Not Found')
              .having((e) => e.statusCode, 'test', 404),
        ),
      );
      verify(
        () => apiClientMock.post(
          ApiEndpoints.baseUrl + ApiEndpoints.login,
          data: data,
          queryParams: query,
        ),
      ).called(1);
    });
  });
}

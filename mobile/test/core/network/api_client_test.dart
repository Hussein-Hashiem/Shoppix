import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/network/api_client.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

class TestApiClient
    with
        ApiClientBase,
        GetApiClient,
        PostApiClient,
        PutApiClient,
        DeleteApiClient {
  @override
  final Dio dio;
  TestApiClient(this.dio);
}

void main() {
  late MockDio dio;
  late TestApiClient client;
  final requestOptions = RequestOptions(path: '/test');

  setUp(() {
    dio = MockDio();
    client = TestApiClient(dio);
  });

  Response okResponse([dynamic data]) =>
      Response(requestOptions: requestOptions, statusCode: 200, data: data);

  DioException createDioException(
    DioExceptionType type, {
    dynamic data,
    int? status,
  }) {
    return DioException(
      requestOptions: requestOptions,
      type: type,
      response: data == null && status == null
          ? null
          : Response(
              requestOptions: requestOptions,
              statusCode: status,
              data: data,
            ),
    );
  }

  group('GET', () {
    test('returns Response when call is successful', () async {
      final response = okResponse({'ok': true});
      when(() => dio.get('/products', queryParameters: {'page': 1}))
          .thenAnswer((_) async => response);

      final result = await client.get('/products', queryParams: {'page': 1});

      expect(result, response);
      verify(() => dio.get('/products', queryParameters: {'page': 1}))
          .called(1);
    });

    test('rethrows exception when dio throws DioException', () async {
      final exception = createDioException(DioExceptionType.connectionTimeout);
      when(() => dio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenThrow(exception);

      expect(() => client.get('/x'), throwsA(isA<Exception>()));
    });
  });

  group('POST', () {
    test('returns Response when call is successful', () async {
      final response = okResponse();
      when(() => dio.post('/login', data: {'email': 'a@a.com'}))
          .thenAnswer((_) async => response);

      final result = await client.post('/login', data: {'email': 'a@a.com'});

      expect(result, response);
      verify(() => dio.post('/login', data: {'email': 'a@a.com'})).called(1);
    });

    test('rethrows exception when dio throws DioException', () async {
      final exception = createDioException(
        DioExceptionType.badResponse,
        status: 400,
      );
      when(() => dio.post(any(), data: any(named: 'data')))
          .thenThrow(exception);

      expect(() => client.post('/login'), throwsA(isA<Exception>()));
    });
  });

  group('PUT', () {
    test('returns Response when call is successful', () async {
      final response = okResponse();
      when(() => dio.put('/p/1', data: {'name': 'x'}))
          .thenAnswer((_) async => response);

      final result = await client.put('/p/1', data: {'name': 'x'});

      expect(result, response);
    });

    test('rethrows exception when dio throws DioException', () async {
      final exception = createDioException(
        DioExceptionType.badResponse,
        status: 404,
      );
      when(() => dio.put(any(), data: any(named: 'data'))).thenThrow(exception);

      expect(() => client.put('/p/1'), throwsA(isA<Exception>()));
    });
  });

  group('DELETE', () {
    test('returns Response when call is successful', () async {
      final response = okResponse();
      when(() => dio.delete('/p/1')).thenAnswer((_) async => response);

      final result = await client.delete('/p/1');

      expect(result, response);
    });

    test('rethrows exception when dio throws DioException', () async {
      final exception = createDioException(DioExceptionType.connectionError);
      when(() => dio.delete(any())).thenThrow(exception);

      expect(() => client.delete('/p/1'), throwsA(isA<Exception>()));
    });
  });
}

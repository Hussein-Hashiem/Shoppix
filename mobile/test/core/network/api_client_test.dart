import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/errors/failures.dart';
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

  Response okResponse([dynamic data]) =>
      Response(requestOptions: requestOptions, statusCode: 200, data: data);

  DioException dioError(DioExceptionType type, {dynamic data, int? status}) {
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

  setUp(() {
    dio = MockDio();
    client = TestApiClient(dio);
  });

  void stubGetThrows(DioException e) {
    when(() => dio.get(any(), queryParameters: any(named: 'queryParameters')))
        .thenThrow(e);
  }

  group('GET', () {
    test('returns Right(response) and forwards path + queryParams', () async {
      final response = okResponse({'ok': true});
      when(() => dio.get('/products', queryParameters: {'page': 1}))
          .thenAnswer((_) async => response);

      final result = await client.get('/products', queryParams: {'page': 1});

      expect(result, Right<Failure, Response>(response));
      verify(() => dio.get('/products', queryParameters: {'page': 1}))
          .called(1);
    });

    test('connectionTimeout -> NetworkFailure(Connection timeout)', () async {
      stubGetThrows(dioError(DioExceptionType.connectionTimeout));

      final result = await client.get('/x');

      expect(
        result,
        const Left<Failure, Response>(NetworkFailure('Connection timeout')),
      );
    });

    test('receiveTimeout -> NetworkFailure(Connection timeout)', () async {
      stubGetThrows(dioError(DioExceptionType.receiveTimeout));

      final result = await client.get('/x');

      expect(
        result,
        const Left<Failure, Response>(NetworkFailure('Connection timeout')),
      );
    });

    test('sendTimeout -> NetworkFailure(Connection timeout)', () async {
      stubGetThrows(dioError(DioExceptionType.sendTimeout));

      final result = await client.get('/x');

      expect(
        result,
        const Left<Failure, Response>(NetworkFailure('Connection timeout')),
      );
    });

    test('badResponse with message -> ServerFailure(message)', () async {
      stubGetThrows(
        dioError(
          DioExceptionType.badResponse,
          status: 401,
          data: {'message': 'Invalid credentials'},
        ),
      );

      final result = await client.get('/x');

      expect(
        result,
        const Left<Failure, Response>(ServerFailure('Invalid credentials')),
      );
    });

    test(
      'badResponse without message key -> ServerFailure(Server error)',
      () async {
        stubGetThrows(
          dioError(
            DioExceptionType.badResponse,
            status: 500,
            data: {'error': 'boom'},
          ),
        );

        final result = await client.get('/x');

        expect(
          result,
          const Left<Failure, Response>(ServerFailure('Server error')),
        );
      },
    );

    test('badResponse with null data -> ServerFailure(Server error)', () async {
      stubGetThrows(
        DioException(
          requestOptions: requestOptions,
          type: DioExceptionType.badResponse,
          response: Response(requestOptions: requestOptions, statusCode: 500),
        ),
      );

      final result = await client.get('/x');

      expect(
        result,
        const Left<Failure, Response>(ServerFailure('Server error')),
      );
    });

    test('badResponse with non-JSON (String/HTML) data -> ServerFailure(Server error)', () async {
      stubGetThrows(
        dioError(
          DioExceptionType.badResponse,
          status: 502,
          data: '<html>Bad Gateway</html>',
        ),
      );

      final result = await client.get('/x');

      expect(
        result,
        const Left<Failure, Response>(ServerFailure('Server error')),
      );
    });

    test(
      'badResponse with non-String message -> ServerFailure(Server error)',
      () async {
        stubGetThrows(
          dioError(
            DioExceptionType.badResponse,
            status: 400,
            data: {
              'message': ['email must be valid'],
            },
          ),
        );

        final result = await client.get('/x');

        expect(
          result,
          const Left<Failure, Response>(ServerFailure('Server error')),
        );
      },
    );

    test(
      'connectionError (no response) -> NetworkFailure(No internet connection)',
      () async {
        stubGetThrows(dioError(DioExceptionType.connectionError));

        final result = await client.get('/x');

        expect(
          result,
          const Left<Failure, Response>(
            NetworkFailure('No internet connection'),
          ),
        );
      },
    );
  });

  group('POST', () {
    test('returns Right(response) and forwards data', () async {
      final response = okResponse();
      when(() => dio.post('/login', data: {'email': 'a@a.com'}))
          .thenAnswer((_) async => response);

      final result = await client.post('/login', data: {'email': 'a@a.com'});

      expect(result, Right<Failure, Response>(response));
      verify(() => dio.post('/login', data: {'email': 'a@a.com'})).called(1);
    });

    test('maps DioException to Left', () async {
      when(() => dio.post(any(), data: any(named: 'data')))
          .thenThrow(dioError(DioExceptionType.connectionTimeout));

      final result = await client.post('/login');

      expect(
        result,
        const Left<Failure, Response>(NetworkFailure('Connection timeout')),
      );
    });
  });

  group('PUT', () {
    test('returns Right(response) and forwards data', () async {
      final response = okResponse();
      when(() => dio.put('/p/1', data: {'name': 'x'}))
          .thenAnswer((_) async => response);

      final result = await client.put('/p/1', data: {'name': 'x'});

      expect(result, Right<Failure, Response>(response));
    });

    test('maps DioException to Left', () async {
      when(() => dio.put(any(), data: any(named: 'data'))).thenThrow(
        dioError(
          DioExceptionType.badResponse,
          status: 404,
          data: {'message': 'Not found'},
        ),
      );

      final result = await client.put('/p/1');

      expect(result, const Left<Failure, Response>(ServerFailure('Not found')));
    });
  });

  group('DELETE', () {
    test('returns Right(response)', () async {
      final response = okResponse();
      when(() => dio.delete('/p/1')).thenAnswer((_) async => response);

      final result = await client.delete('/p/1');

      expect(result, Right<Failure, Response>(response));
    });

    test('maps DioException to Left', () async {
      when(() => dio.delete(any()))
          .thenThrow(dioError(DioExceptionType.connectionError));

      final result = await client.delete('/p/1');

      expect(
        result,
        const Left<Failure, Response>(NetworkFailure('No internet connection')),
      );
    });
  });
}

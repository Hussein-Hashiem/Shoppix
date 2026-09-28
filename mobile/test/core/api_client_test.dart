import 'dart:convert';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/errors/failures.dart';
import 'package:mobile/core/network/api_client.dart';

void main() {
  group('ApiClient', () {
    late _RecordingAdapter adapter;
    late _TestApiClient client;

    setUp(() {
      adapter = _RecordingAdapter();
      client = _TestApiClient(
        Dio(BaseOptions(baseUrl: 'https://example.test'))
          ..httpClientAdapter = adapter,
      );
    });

    tearDown(() {
      client.dio.close(force: true);
    });

    test('GET forwards path and query parameters', () async {
      final result = await client.get('/items', queryParams: {'page': 2});

      expect(result, isA<Right<Failure, Response>>());
      expect(adapter.lastRequest.method, 'GET');
      expect(adapter.lastRequest.path, '/items');
      expect(adapter.lastRequest.queryParameters, {'page': 2});
    });

    test('POST forwards its body', () async {
      final result = await client.post('/items', data: {'name': 'Desk'});

      expect(result, isA<Right<Failure, Response>>());
      expect(adapter.lastRequest.method, 'POST');
      expect(adapter.requestBody, {'name': 'Desk'});
    });

    test('PUT forwards its body', () async {
      final result = await client.put('/items/1', data: {'name': 'Chair'});

      expect(result, isA<Right<Failure, Response>>());
      expect(adapter.lastRequest.method, 'PUT');
      expect(adapter.requestBody, {'name': 'Chair'});
    });

    test('DELETE forwards the path', () async {
      final result = await client.delete('/items/1');

      expect(result, isA<Right<Failure, Response>>());
      expect(adapter.lastRequest.method, 'DELETE');
      expect(adapter.lastRequest.path, '/items/1');
    });

    test('maps response errors to ServerException', () async {
      adapter.statusCode = 503;
      adapter.responseBody = jsonEncode({'message': 'Service unavailable'});

      final result = await client.get('/items');

      expect(result, isA<Left<Failure, Response>>());
      result.fold(
        (failure) =>
            expect(failure, const ServerFailure('Service unavailable')),
        (_) => fail('Expected a server failure'),
      );
    });

    test('maps timeouts to NetworkException', () async {
      adapter.errorType = DioExceptionType.connectionTimeout;

      final result = await client.get('/items');

      expect(result, isA<Left<Failure, Response>>());
      result.fold(
        (failure) =>
            expect(failure, const NetworkFailure('Connection timeout')),
        (_) => fail('Expected a network failure'),
      );
    });

    test('maps other transport errors to NetworkException', () async {
      adapter.errorType = DioExceptionType.connectionError;

      final result = await client.get('/items');

      expect(result, isA<Left<Failure, Response>>());
      result.fold(
        (failure) =>
            expect(failure, const NetworkFailure('No internet connection')),
        (_) => fail('Expected a network failure'),
      );
    });
  });
}

class _TestApiClient
    with
        ApiClientBase,
        GetApiClient,
        PostApiClient,
        PutApiClient,
        DeleteApiClient {
  _TestApiClient(this.dio);

  @override
  final Dio dio;
}

class _RecordingAdapter implements HttpClientAdapter {
  int statusCode = 200;
  String responseBody = '{"ok":true}';
  DioExceptionType? errorType;
  late RequestOptions lastRequest;
  dynamic requestBody;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastRequest = options;
    if (requestStream != null) {
      final bytes = await requestStream.fold<BytesBuilder>(
        BytesBuilder(),
        (builder, chunk) => builder..add(chunk),
      );
      requestBody = jsonDecode(utf8.decode(bytes.takeBytes()));
    }

    if (errorType case final type?) {
      throw DioException(requestOptions: options, type: type);
    }

    return ResponseBody.fromString(
      responseBody,
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

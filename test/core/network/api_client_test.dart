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

// import 'package:dio/dio.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mobile/core/network/api_client.dart';
// import 'package:mocktail/mocktail.dart';

// class MockDio extends Mock implements Dio {}

// class TestApiClient
//     with
//         ApiClientBase,
//         GetApiClient,
//         PostApiClient,
//         PutApiClient,
//         DeleteApiClient {
//   @override
//   final Dio dio;
//   TestApiClient(this.dio);
// }

// void main() {
//   late MockDio dio;
//   late TestApiClient client;
//   final requestOptions = RequestOptions(path: '/test');

//   setUp(() {
//     dio = MockDio();
//     client = TestApiClient(dio);
//   });

//   Response okResponse([dynamic data]) =>
//       Response(requestOptions: requestOptions, statusCode: 200, data: data);

//   DioException createDioException(
//     DioExceptionType type, {
//     dynamic data,
//     int? status,
//   }) {
//     return DioException(
//       requestOptions: requestOptions,
//       type: type,
//       response: data == null && status == null
//           ? null
//           : Response(
//               requestOptions: requestOptions,
//               statusCode: status,
//               data: data,
//             ),
//     );
//   }

//   group('GET', () {
//     test('returns Response when call is successful', () async {
//       final response = okResponse({'ok': true});
//       when(() => dio.get('/products', queryParameters: {'page': 1}))
//           .thenAnswer((_) async => response);

//       final result = await client.get('/products', queryParams: {'page': 1});

//       expect(result, response);
//       verify(() => dio.get('/products', queryParameters: {'page': 1}))
//           .called(1);
//     });

//     test('rethrows exception when dio throws DioException', () async {
//       final exception = createDioException(DioExceptionType.connectionTimeout);
//       when(() => dio.get(any(), queryParameters: any(named: 'queryParameters')))
//           .thenThrow(exception);

//       expect(() => client.get('/x'), throwsA(isA<Exception>()));
//     });
//   });

//   group('POST', () {
//     test('returns Response when call is successful', () async {
//       final response = okResponse();
//       when(() => dio.post('/login', data: {'email': 'a@a.com'}))
//           .thenAnswer((_) async => response);

//       final result = await client.post('/login', data: {'email': 'a@a.com'});

//       expect(result, response);
//       verify(() => dio.post('/login', data: {'email': 'a@a.com'})).called(1);
//     });

//     test('rethrows exception when dio throws DioException', () async {
//       final exception = createDioException(
//         DioExceptionType.badResponse,
//         status: 400,
//       );
//       when(() => dio.post(any(), data: any(named: 'data')))
//           .thenThrow(exception);

//       expect(() => client.post('/login'), throwsA(isA<Exception>()));
//     });
//   });

//   group('PUT', () {
//     test('returns Response when call is successful', () async {
//       final response = okResponse();
//       when(() => dio.put('/p/1', data: {'name': 'x'}))
//           .thenAnswer((_) async => response);

//       final result = await client.put('/p/1', data: {'name': 'x'});

//       expect(result, response);
//     });

//     test('rethrows exception when dio throws DioException', () async {
//       final exception = createDioException(
//         DioExceptionType.badResponse,
//         status: 404,
//       );
//       when(() => dio.put(any(), data: any(named: 'data'))).thenThrow(exception);

//       expect(() => client.put('/p/1'), throwsA(isA<Exception>()));
//     });
//   });

//   group('DELETE', () {
//     test('returns Response when call is successful', () async {
//       final response = okResponse();
//       when(() => dio.delete('/p/1')).thenAnswer((_) async => response);

//       final result = await client.delete('/p/1');

//       expect(result, response);
//     });

//     test('rethrows exception when dio throws DioException', () async {
//       final exception = createDioException(DioExceptionType.connectionError);
//       when(() => dio.delete(any())).thenThrow(exception);

//       expect(() => client.delete('/p/1'), throwsA(isA<Exception>()));
//     });
//   });
// }

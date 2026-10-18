import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/errors/exception.dart';
import 'package:mobile/core/errors/exception_handler.dart';
import 'package:mobile/core/errors/failures.dart';

void main() {
  late ExceptionHandler exceptionHandler;

  setUp(() {
    exceptionHandler = ExceptionHandler();
  });
  group("test all the possible server failures", () {
    final testCases = [
      {
        'statusCode': 400,
        'message':
            'Invalid request. Please check your information and try again.',
      },
      {
        'statusCode': 401,
        'message': 'Your session may have expired. Please sign in again.',
      },
      {
        'statusCode': 403,
        'message': 'You don’t have permission to perform this action.',
      },
      {
        'statusCode': 404,
        'message': 'The requested information could not be found.',
      },
      {
        'statusCode': 408,
        'message': 'The request took too long. Please try again.',
      },
      {
        'statusCode': 409,
        'message': 'This action conflicts with existing information. Please review your input.',
      },
      {
        'statusCode': 422,
        'message': 'Some of the information you entered is invalid. Please check it and try again.',
      },
      {
        'statusCode': 429,
        'message': 'You’ve made too many requests. Please wait a moment and try again.',
      },
      {
        'statusCode': 500,
        'message': 'We’re having trouble processing your request. Please try again later.',
      },
      {
        'statusCode': 501,
        'message': 'We’re having trouble processing your request. Please try again later.',
      },
      {
        'statusCode': 502,
        'message': 'We’re having trouble processing your request. Please try again later.',
      },
      {
        'statusCode': 503,
        'message': 'We’re having trouble processing your request. Please try again later.',
      },
      {
        'statusCode': 504,
        'message': 'We’re having trouble processing your request. Please try again later.',
      },
    ];
    test("test if server failure is returned successfully ", () {
      for (final testCase in testCases) {
        final expected = ServerFailure(testCase['message']! as String);
        final result = exceptionHandler.handleException(
          ServerException(
            message: testCase['message']! as String,
            statusCode: testCase['statusCode'] as int,
          ),
        );

        expect(result, expected);
      }
    });
  });

  group('handleNetworkException', () {
    final testCases = <String>[
      'The connection is taking too long. Please check your internet connection and try again.',
      'Your request is taking too long to send. Please try again.',
      'The server is taking too long to respond. Please try again later.',
      'Unable to connect. Please check your internet connection.',
      'The request was cancelled.',
      'A secure connection could not be established. Please try again later.',
      'Something went wrong. Please try again later.',
    ];

    for (final message in testCases) {
      test('returns NetworkFailure with message: $message', () {
        final exception = NetworkException(message: message);
        final expected = NetworkFailure(message);
        final result = exceptionHandler.handleException(exception);

        expect(result, expected);
      });
    }
  });
}

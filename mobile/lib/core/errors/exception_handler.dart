import 'package:mobile/core/errors/exception.dart';
import 'package:mobile/core/errors/failures.dart';

class ExceptionHandler {
  Failure handleException(Exception e) {
    if (e is ServerException) {
      return handleServerException(e);
    }
    if (e is NetworkException) {
      return handleNetworkException(e);
    }
    return const UnexpectedFailure('Unexpected error occurred');
  }

  ServerFailure handleServerException(ServerException exception) {
    switch (exception.statusCode) {
      // Client errors
      case 400:
        return ServerFailure(
          'Invalid request. Please check your information and try again.',
        );

      case 401:
        return ServerFailure(
          'Your session may have expired. Please sign in again.',
        );

      case 403:
        return ServerFailure(
          'You don’t have permission to perform this action.',
        );

      case 404:
        return ServerFailure('The requested information could not be found.');

      case 408:
        return ServerFailure('The request took too long. Please try again.');

      case 409:
        return ServerFailure(
          'This action conflicts with existing information. Please review your input.',
        );

      case 422:
        return ServerFailure(
          'Some of the information you entered is invalid. Please check it and try again.',
        );

      case 429:
        return ServerFailure(
          'You’ve made too many requests. Please wait a moment and try again.',
        );

      // Server errors
      case 500:
      case 501:
      case 502:
      case 503:
      case 504:
        return ServerFailure(
          'We’re having trouble processing your request. Please try again later.',
        );

      default:
        return ServerFailure('Something went wrong. Please try again later.');
    }
  }

  NetworkFailure handleNetworkException(NetworkException exception) {
    return NetworkFailure(exception.message);
  }
}

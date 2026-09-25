import 'package:dio/dio.dart';

import 'error_model.dart';

//!ServerException
class ServerException implements Exception {
  final ErrorModel errorModel;
  ServerException(this.errorModel);
}

//!CacheExeption
class CacheExeption implements Exception {
  final String errorMessage;
  CacheExeption({required this.errorMessage});
}

class BadCertificateException extends ServerException {
  BadCertificateException(super.errorModel);
}

class ConnectionTimeoutException extends ServerException {
  ConnectionTimeoutException(super.errorModel);
}

class BadResponseException extends ServerException {
  BadResponseException(super.errorModel);
}

class ReceiveTimeoutException extends ServerException {
  ReceiveTimeoutException(super.errorModel);
}

class ConnectionErrorException extends ServerException {
  ConnectionErrorException(super.errorModel);
}

class SendTimeoutException extends ServerException {
  SendTimeoutException(super.errorModel);
}

class UnauthorizedException extends ServerException {
  UnauthorizedException(super.errorModel);
}

class ForbiddenException extends ServerException {
  ForbiddenException(super.errorModel);
}

class NotFoundException extends ServerException {
  NotFoundException(super.errorModel);
}

class CofficientException extends ServerException {
  CofficientException(super.errorModel);
}

class CancelException extends ServerException {
  CancelException(super.errorModel);
}

class UnknownException extends ServerException {
  UnknownException(super.errorModel);
}

ErrorModel _errorModelFromResponse<T>(
  Response<T>? response, {
  required int fallbackStatus,
  required String fallbackMessage,
}) {
  final Object? data = response?.data;
  if (data is Map) {
    return ErrorModel.fromJson(Map<String, dynamic>.from(data));
  }

  return ErrorModel(
    status: response?.statusCode ?? fallbackStatus,
    errorMessage: data?.toString() ?? fallbackMessage,
  );
}

void handleDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionError:
      throw ConnectionErrorException(
        _errorModelFromResponse(
          e.response,
          fallbackStatus: 503,
          fallbackMessage: e.message ?? 'Connection error',
        ),
      );
    case DioExceptionType.badCertificate:
      throw BadCertificateException(
        _errorModelFromResponse(
          e.response,
          fallbackStatus: 495,
          fallbackMessage: e.message ?? 'Bad certificate',
        ),
      );
    case DioExceptionType.connectionTimeout:
      throw ConnectionTimeoutException(
        _errorModelFromResponse(
          e.response,
          fallbackStatus: 408,
          fallbackMessage: e.message ?? 'Connection timeout',
        ),
      );

    case DioExceptionType.receiveTimeout:
      throw ReceiveTimeoutException(
        _errorModelFromResponse(
          e.response,
          fallbackStatus: 408,
          fallbackMessage: e.message ?? 'Receive timeout',
        ),
      );

    case DioExceptionType.sendTimeout:
      throw SendTimeoutException(
        _errorModelFromResponse(
          e.response,
          fallbackStatus: 408,
          fallbackMessage: e.message ?? 'Send timeout',
        ),
      );

    case DioExceptionType.transformTimeout:
      throw ReceiveTimeoutException(
        _errorModelFromResponse(
          e.response,
          fallbackStatus: 408,
          fallbackMessage: e.message ?? 'Response transform timeout',
        ),
      );

    case DioExceptionType.badResponse:
      switch (e.response?.statusCode) {
        case 400: // Bad request
          throw BadResponseException(
            _errorModelFromResponse(
              e.response,
              fallbackStatus: 400,
              fallbackMessage: 'Bad request',
            ),
          );

        case 401: //unauthorized
          throw UnauthorizedException(
            _errorModelFromResponse(
              e.response,
              fallbackStatus: 401,
              fallbackMessage: 'Unauthorized',
            ),
          );

        case 403: //forbidden
          throw ForbiddenException(
            _errorModelFromResponse(
              e.response,
              fallbackStatus: 403,
              fallbackMessage: 'Forbidden',
            ),
          );

        case 404: //not found
          throw NotFoundException(
            _errorModelFromResponse(
              e.response,
              fallbackStatus: 404,
              fallbackMessage: 'Resource not found',
            ),
          );

        case 409: //cofficient
          throw CofficientException(
            _errorModelFromResponse(
              e.response,
              fallbackStatus: 409,
              fallbackMessage: 'Request conflict',
            ),
          );

        case 504: // Bad request
          throw BadResponseException(
            _errorModelFromResponse(
              e.response,
              fallbackStatus: 504,
              fallbackMessage: 'Gateway timeout',
            ),
          );

        default:
          throw UnknownException(
            _errorModelFromResponse(
              e.response,
              fallbackStatus: 500,
              fallbackMessage: 'Unexpected server response',
            ),
          );
      }

    case DioExceptionType.cancel:
      throw CancelException(
        ErrorModel(errorMessage: e.toString(), status: 500),
      );

    case DioExceptionType.unknown:
      throw UnknownException(
        ErrorModel(errorMessage: e.toString(), status: 500),
      );
  }
}

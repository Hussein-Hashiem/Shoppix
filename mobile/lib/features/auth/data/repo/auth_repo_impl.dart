import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:mobile/core/errors/exception.dart';
import 'package:mobile/core/errors/exception_handler.dart';
import 'package:mobile/core/errors/failures.dart';
import 'package:mobile/features/auth/data/data_source/server_datasource.dart';
import 'package:mobile/features/auth/data/models/login_model.dart';
import 'package:mobile/features/auth/domain/entities/login_entity.dart';
import 'package:mobile/features/auth/domain/repo/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final ServerDatasource serverDatasource;

  AuthRepoImpl({required this.serverDatasource});

  @override
  Future<Either<Failure, LoginEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final LoginModel response = await serverDatasource.login(
        email: email,
        password: password,
      );
      return right(LoginEntity(token: response.token));
    } on ServerException catch (e) {
      final ExceptionHandler exceptionHandler = ExceptionHandler();
      return left(exceptionHandler.handleException(e));
    } on NetworkException catch (e) {
      final ExceptionHandler exceptionHandler = ExceptionHandler();
      return left(exceptionHandler.handleException(e));
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<Either<Failure, Unit>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      await serverDatasource.register(
        email: email,
        name: name,
        password: password,
      );
      return right(unit);
    } on ServerException catch (e) {
      final ExceptionHandler exceptionHandler = ExceptionHandler();
      return left(exceptionHandler.handleException(e));
    } on NetworkException catch (e) {
      final ExceptionHandler exceptionHandler = ExceptionHandler();
      return left(exceptionHandler.handleException(e));
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}

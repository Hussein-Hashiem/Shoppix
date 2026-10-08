import 'package:dartz/dartz.dart';
import 'package:mobile/core/errors/exception.dart';
import 'package:mobile/core/errors/failures.dart';
import 'package:mobile/features/auth/data/data_source/server_datasource.dart';
import 'package:mobile/features/auth/domain/repo/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final ServerDatasource serverDatasource;

  AuthRepoImpl({required this.serverDatasource});

  @override
  Future<Either<Failure, Unit>> login({
    required String email,
    required String password,
  }) async {
    return right(unit);
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
      rethrow;
    }
  }
}

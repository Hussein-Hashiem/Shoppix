import 'package:dartz/dartz.dart';
import 'package:mobile/core/errors/failures.dart';
import 'package:mobile/features/auth/domain/repo/auth_repo.dart';

class AuthRepoImpl implements AuthRepo{
  @override
  Future<Either<Failure, Unit>> login({required String email, required String password}) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> register({required String name, required String email, required String password}) {
    // TODO: implement register
    throw UnimplementedError();
  }
}
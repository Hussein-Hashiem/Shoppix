import 'package:dartz/dartz.dart';
import 'package:mobile/core/errors/failures.dart';

abstract class AuthRepo {
  Future<Either<Failure, Unit>> register({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, Unit>> login({
    required String email,
    required String password,
  });
}

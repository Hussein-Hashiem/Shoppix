import 'package:dartz/dartz.dart';
import 'package:mobile/core/errors/failures.dart';
import 'package:mobile/features/auth/domain/entities/login_entity.dart';

abstract class AuthRepo {
  Future<Either<Failure, Unit>> register({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, LoginEntity>> login({
    required String email,
    required String password,
  });
}

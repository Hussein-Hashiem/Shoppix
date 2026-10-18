import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile/core/errors/failures.dart';
import 'package:mobile/core/usecases/usecase.dart';
import 'package:mobile/features/auth/domain/entities/login_entity.dart';
import 'package:mobile/features/auth/domain/repo/auth_repo.dart';

class LoginUsecase implements UseCase<LoginEntity, LoginParams> {
  final AuthRepo authRepo;
  LoginUsecase(this.authRepo);
  @override
  Future<Either<Failure, LoginEntity>> call(LoginParams params) async {
    return await authRepo.login(email: params.email, password: params.password);
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;

  new({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

import 'package:dartz/dartz.dart';
import 'package:mobile/core/errors/failures.dart';
import 'package:mobile/core/usecases/usecase.dart';
import 'package:mobile/features/auth/domain/repo/auth_repo.dart';

class LoginUsecase implements UseCase<Unit, LoginParams> {
  final AuthRepo authRepo;
  LoginUsecase(this.authRepo);
  @override
  Future<Either<Failure, Unit>> call(LoginParams params) async {
    return await authRepo.login(email: params.email, password: params.password);
  }
}

class LoginParams {
  final String email;
  final String password;

  new({required this.email, required this.password});
}

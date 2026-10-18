import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile/core/errors/failures.dart';
import 'package:mobile/core/usecases/usecase.dart';
import 'package:mobile/features/auth/domain/repo/auth_repo.dart';

class RegisterUsecase implements UseCase<Unit, RegisterParams> {
  final AuthRepo authRepo;
  RegisterUsecase(this.authRepo);
  @override
  Future<Either<Failure, Unit>> call(RegisterParams params) async {
    return await authRepo.register(
      email: params.email,
      name: params.name,
      password: params.password,
    );
  }
}

class RegisterParams extends Equatable {
  final String email;
  final String name;
  final String password;

  new({required this.email, required this.name, required this.password});

  @override
  List<Object?> get props => [email, name, password];
}

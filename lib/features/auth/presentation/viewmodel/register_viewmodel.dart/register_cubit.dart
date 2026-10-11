import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/auth/domain/usecases/register_usecase.dart';
import 'package:mobile/features/auth/presentation/viewmodel/login_viewmodel/login_states.dart';

class RegisterViewmodel extends Cubit<LoginStates> {
  RegisterViewmodel(this.registerUsecase) : super(InitialAuthState());
  final RegisterUsecase registerUsecase;

  void register({
    required String email,
    required String password,
    required String name,
  }) async {
    emit(LoadingAuthState());
    final result = await registerUsecase(
      RegisterParams(email: email, password: password, name: name),
    );
    result.fold(
      (failure) => emit(FailAuthState(message: failure.message)),
      (success) => emit(SuccessAuthState()),
    );
  }
}

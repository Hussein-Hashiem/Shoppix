import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/auth/domain/usecases/login_usecase.dart';
import 'package:mobile/features/auth/presentation/viewmodel/login_viewmodel/login_states.dart';

class LoginViewmodel extends Cubit<LoginStates> {
  LoginViewmodel(this.loginUsecase) : super(InitialAuthState());
  final LoginUsecase loginUsecase;

  void login({required String email, required String password}) async {
    emit(LoadingAuthState());
    final result = await loginUsecase(
      LoginParams(email: email, password: password),
    );
    result.fold(
      (failure) => emit(FailAuthState(message: failure.message)),
      (success) => emit(SuccessAuthState()),
    );
  }
}

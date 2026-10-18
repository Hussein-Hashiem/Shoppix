import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/auth/domain/usecases/register_usecase.dart';
import 'package:mobile/features/auth/presentation/viewmodel/login_viewmodel/login_states.dart';
import 'package:mobile/features/auth/presentation/viewmodel/register_viewmodel.dart/register_states.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this.registerUsecase) : super(InitialRegisterState());
  final RegisterUsecase registerUsecase;

  void register({
    required String email,
    required String password,
    required String name,
  }) async {
    emit(LoadingRegisterState());
    final result = await registerUsecase(
      RegisterParams(email: email, password: password, name: name),
    );
    result.fold(
      (failure) => emit(FailRegisterState(message: failure.message)),
      (success) => emit(SuccessRegisterState()),
    );
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile/core/di/di.dart';
import 'package:mobile/core/storage/secure_storage.dart';
import 'package:mobile/features/auth/domain/usecases/login_usecase.dart';
import 'package:mobile/features/auth/presentation/viewmodel/login_viewmodel/login_states.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit(this.loginUsecase) : super(InitialLoginState());
  final LoginUsecase loginUsecase;
  final SecureTokenStorage tokenStorage = SecureTokenStorage(
    FlutterSecureStorage(
      aOptions: AndroidOptions(),
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    ),
  );

  void login({required String email, required String password}) async {
    emit(LoadingLoginState());
    final result = await loginUsecase(
      LoginParams(email: email, password: password),
    );
    result.fold((failure) => emit(FailLoginState(message: failure.message)), (
      success,
    ) async {
      await tokenStorage.saveToken(success.token);
      emit(SuccessLoginState());
    });
  }
}

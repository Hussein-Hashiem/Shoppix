abstract class RegisterState {}

class InitialAuthState extends RegisterState {}

class LoadingAuthState extends RegisterState {}

class SuccessAuthState extends RegisterState {}

class FailAuthState extends RegisterState {
  final String message;
  FailAuthState({required this.message});
}

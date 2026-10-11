abstract class LoginStates {}

class InitialAuthState extends LoginStates {}

class LoadingAuthState extends LoginStates {}

class SuccessAuthState extends LoginStates {}

class FailAuthState extends LoginStates {
  final String message;
  FailAuthState({required this.message});
}

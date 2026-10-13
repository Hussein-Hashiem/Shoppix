import 'package:equatable/equatable.dart';

abstract class LoginStates extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialLoginState extends LoginStates {}

class LoadingLoginState extends LoginStates {}

class SuccessLoginState extends LoginStates {}

class FailLoginState extends LoginStates {
  final String message;
  FailLoginState({required this.message});
}

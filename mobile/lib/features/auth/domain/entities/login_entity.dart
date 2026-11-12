import 'package:equatable/equatable.dart';

class LoginEntity extends Equatable {
  final String token;

  const LoginEntity({required this.token});

  @override
  List<Object?> get props => [token];
}

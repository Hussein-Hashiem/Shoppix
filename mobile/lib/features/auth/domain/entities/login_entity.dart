import 'package:equatable/equatable.dart';

class LoginEntity extends Equatable {
  final String token;

  new({required this.token});

  @override
  List<Object?> get props => [token];
}

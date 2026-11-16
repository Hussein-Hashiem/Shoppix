import 'package:equatable/equatable.dart';

class LoginEntity extends Equatable {
  final String token;
  final String name;
  final String email;

  new({required this.token, this.name = '', this.email = ''});

  @override
  List<Object?> get props => [token, name, email];
}

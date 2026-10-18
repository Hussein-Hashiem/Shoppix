import 'package:mobile/features/auth/domain/entities/login_entity.dart';

class LoginModel extends LoginEntity {
  final String name;
  final String email;
  final String refreshToken;
  final int expiresIn;

  new({
    required super.token,
    required this.name,
    required this.email,
    required this.refreshToken,
    required this.expiresIn,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      token: json['token'],
      name: json['name'],
      email: json['email'],
      refreshToken: json['refreshToken'],
      expiresIn: json['expiresIn'],
    );
  }
}

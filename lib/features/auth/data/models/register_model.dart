class RegisterModel {
  final String email;
  final String name;
  final String userId;

  RegisterModel({
    required this.email,
    required this.name,
    required this.userId,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      email: json['email'],
      name: json['name'],
      userId: json['userId'],
    );
  }
}

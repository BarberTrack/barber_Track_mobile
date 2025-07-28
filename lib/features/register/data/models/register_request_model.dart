import '../../domain/entities/register_request.dart';

class RegisterRequestModel extends RegisterRequest {
  const RegisterRequestModel({
    required super.email,
    required super.password,
    required super.firstName,
    required super.lastName,
    required super.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
    };
  }

  factory RegisterRequestModel.fromEntity(RegisterRequest entity) {
    return RegisterRequestModel(
      email: entity.email,
      password: entity.password,
      firstName: entity.firstName,
      lastName: entity.lastName,
      phone: entity.phone,
    );
  }
}

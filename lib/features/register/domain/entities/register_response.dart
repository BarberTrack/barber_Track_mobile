import 'user.dart';

abstract class RegisterResponse {
  final bool success;
  final String message;
  final RegisterData data;

  const RegisterResponse({
    required this.success,
    required this.message,
    required this.data,
  });
}

abstract class RegisterData {
  final bool success;
  final AuthData data;
  final DateTime timestamp;
  final String service;

  const RegisterData({
    required this.success,
    required this.data,
    required this.timestamp,
    required this.service,
  });
}

abstract class AuthData {
  final bool success;
  final UserAuthData data;
  final DateTime timestamp;
  final String service;

  const AuthData({
    required this.success,
    required this.data,
    required this.timestamp,
    required this.service,
  });
}

abstract class UserAuthData {
  final User user;
  final String token;
  final int expiresIn;

  const UserAuthData({
    required this.user,
    required this.token,
    required this.expiresIn,
  });
}

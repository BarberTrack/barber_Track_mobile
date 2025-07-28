import '../../domain/entities/register_response.dart';
import 'user_model.dart';

class RegisterResponseModel extends RegisterResponse {
  const RegisterResponseModel({
    required super.success,
    required super.message,
    required super.data,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: RegisterDataModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': (data as RegisterDataModel).toJson(),
    };
  }
}

class RegisterDataModel extends RegisterData {
  const RegisterDataModel({
    required super.success,
    required super.data,
    required super.timestamp,
    required super.service,
  });

  factory RegisterDataModel.fromJson(Map<String, dynamic> json) {
    return RegisterDataModel(
      success: json['success'] as bool,
      data: AuthDataModel.fromJson(json['data'] as Map<String, dynamic>),
      timestamp: DateTime.parse(json['timestamp'] as String),
      service: json['service'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': (data as AuthDataModel).toJson(),
      'timestamp': timestamp.toIso8601String(),
      'service': service,
    };
  }
}

class AuthDataModel extends AuthData {
  const AuthDataModel({
    required super.success,
    required super.data,
    required super.timestamp,
    required super.service,
  });

  factory AuthDataModel.fromJson(Map<String, dynamic> json) {
    return AuthDataModel(
      success: json['success'] as bool,
      data: UserAuthDataModel.fromJson(json['data'] as Map<String, dynamic>),
      timestamp: DateTime.parse(json['timestamp'] as String),
      service: json['service'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': (data as UserAuthDataModel).toJson(),
      'timestamp': timestamp.toIso8601String(),
      'service': service,
    };
  }
}

class UserAuthDataModel extends UserAuthData {
  const UserAuthDataModel({
    required super.user,
    required super.token,
    required super.expiresIn,
  });

  factory UserAuthDataModel.fromJson(Map<String, dynamic> json) {
    return UserAuthDataModel(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String,
      expiresIn: json['expiresIn'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': (user as UserModel).toJson(),
      'token': token,
      'expiresIn': expiresIn,
    };
  }
}

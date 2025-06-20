import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

class LoginResponseModel extends Equatable {
  final bool success;
  final String message;
  final LoginDataWrapper data;

  const LoginResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: LoginDataWrapper.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data.toJson()};
  }

  @override
  List<Object> get props => [success, message, data];
}

class LoginDataWrapper extends Equatable {
  final bool success;
  final LoginInnerData data;
  final String timestamp;
  final String service;

  const LoginDataWrapper({
    required this.success,
    required this.data,
    required this.timestamp,
    required this.service,
  });

  factory LoginDataWrapper.fromJson(Map<String, dynamic> json) {
    return LoginDataWrapper(
      success: json['success'] ?? false,
      data: LoginInnerData.fromJson(json['data']),
      timestamp: json['timestamp'] ?? '',
      service: json['service'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.toJson(),
      'timestamp': timestamp,
      'service': service,
    };
  }

  @override
  List<Object> get props => [success, data, timestamp, service];
}

class LoginInnerData extends Equatable {
  final bool success;
  final LoginFinalData data;
  final String timestamp;
  final String service;

  const LoginInnerData({
    required this.success,
    required this.data,
    required this.timestamp,
    required this.service,
  });

  factory LoginInnerData.fromJson(Map<String, dynamic> json) {
    return LoginInnerData(
      success: json['success'] ?? false,
      data: LoginFinalData.fromJson(json['data']),
      timestamp: json['timestamp'] ?? '',
      service: json['service'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.toJson(),
      'timestamp': timestamp,
      'service': service,
    };
  }

  @override
  List<Object> get props => [success, data, timestamp, service];
}

class LoginFinalData extends Equatable {
  final UserDetailsModel user;
  final String token;
  final int expiresIn;

  const LoginFinalData({
    required this.user,
    required this.token,
    required this.expiresIn,
  });

  factory LoginFinalData.fromJson(Map<String, dynamic> json) {
    return LoginFinalData(
      user: UserDetailsModel.fromJson(json['user']),
      token: json['token'] ?? '',
      expiresIn: json['expiresIn'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'user': user.toJson(), 'token': token, 'expiresIn': expiresIn};
  }

  @override
  List<Object> get props => [user, token, expiresIn];
}

class UserDetailsModel extends Equatable {
  final String id;
  final String email;
  final String phone;
  final String firstName;
  final String lastName;
  final String? profileImageUrl;
  final dynamic location;
  final Map<String, dynamic> notificationPreferences;
  final Map<String, dynamic> behaviorPatterns;
  final String createdAt;
  final bool emailVerified;
  final bool phoneVerified;
  final String authProvider;

  const UserDetailsModel({
    required this.id,
    required this.email,
    required this.phone,
    required this.firstName,
    required this.lastName,
    this.profileImageUrl,
    this.location,
    required this.notificationPreferences,
    required this.behaviorPatterns,
    required this.createdAt,
    required this.emailVerified,
    required this.phoneVerified,
    required this.authProvider,
  });

  factory UserDetailsModel.fromJson(Map<String, dynamic> json) {
    return UserDetailsModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      profileImageUrl: json['profileImageUrl'],
      location: json['location'],
      notificationPreferences: json['notificationPreferences'] ?? {},
      behaviorPatterns: json['behaviorPatterns'] ?? {},
      createdAt: json['createdAt'] ?? '',
      emailVerified: json['emailVerified'] ?? false,
      phoneVerified: json['phoneVerified'] ?? false,
      authProvider: json['authProvider'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone': phone,
      'firstName': firstName,
      'lastName': lastName,
      'profileImageUrl': profileImageUrl,
      'location': location,
      'notificationPreferences': notificationPreferences,
      'behaviorPatterns': behaviorPatterns,
      'createdAt': createdAt,
      'emailVerified': emailVerified,
      'phoneVerified': phoneVerified,
      'authProvider': authProvider,
    };
  }

  @override
  List<Object?> get props => [
    id,
    email,
    phone,
    firstName,
    lastName,
    profileImageUrl,
    location,
    notificationPreferences,
    behaviorPatterns,
    createdAt,
    emailVerified,
    phoneVerified,
    authProvider,
  ];
}

class UserModel extends User {
  const UserModel({required super.accessToken});

  factory UserModel.fromLoginResponse(LoginResponseModel response) {
    return UserModel(accessToken: response.data.data.data.token);
  }
}

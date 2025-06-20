import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

class LoginResponseModel extends Equatable {
  final String accessToken;

  const LoginResponseModel({required this.accessToken});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(accessToken: json['access_token'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'access_token': accessToken};
  }

  @override
  List<Object> get props => [accessToken];
}

class UserModel extends User {
  const UserModel({required super.accessToken});

  factory UserModel.fromLoginResponse(LoginResponseModel response) {
    return UserModel(accessToken: response.accessToken);
  }
}

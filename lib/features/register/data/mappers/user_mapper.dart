import '../../domain/entities/user.dart';
import '../../domain/entities/register_request.dart';
import '../../domain/entities/register_response.dart';
import '../models/user_model.dart';
import '../models/register_request_model.dart';
import '../models/register_response_model.dart';

class UserMapper {
  static User toEntity(UserModel model) {
    return UserModel(
      id: model.id,
      email: model.email,
      phone: model.phone,
      firstName: model.firstName,
      lastName: model.lastName,
      profileImageUrl: model.profileImageUrl,
      location: model.location,
      notificationPreferences: model.notificationPreferences,
      behaviorPatterns: model.behaviorPatterns,
      createdAt: model.createdAt,
      emailVerified: model.emailVerified,
      phoneVerified: model.phoneVerified,
      authProvider: model.authProvider,
    );
  }

  static RegisterRequestModel toModel(RegisterRequest entity) {
    return RegisterRequestModel(
      email: entity.email,
      password: entity.password,
      firstName: entity.firstName,
      lastName: entity.lastName,
      phone: entity.phone,
    );
  }

  static RegisterResponse toRegisterResponseEntity(
    RegisterResponseModel model,
  ) {
    return RegisterResponseModel(
      success: model.success,
      message: model.message,
      data: model.data,
    );
  }
}

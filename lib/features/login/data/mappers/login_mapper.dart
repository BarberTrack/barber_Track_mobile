import '../../domain/entities/user.dart';
import '../models/login_response_model.dart';

class LoginMapper {
  static User toEntity(LoginResponseModel model) {
    return UserModel(accessToken: model.accessToken);
  }
}

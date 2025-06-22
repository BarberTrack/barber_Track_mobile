import '../../domain/entities/user.dart';
import '../models/login_response_model.dart';

class LoginMapper {
  static User toEntity(LoginResponseModel model) {
    // Extraer el token de la estructura anidada: data.data.data.token
    final token = model.data.data.data.token;
    return UserModel(accessToken: token);
  }
}

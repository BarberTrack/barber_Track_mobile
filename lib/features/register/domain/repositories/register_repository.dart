import '../entities/register_request.dart';
import '../entities/register_response.dart';

abstract class RegisterRepository {
  Future<RegisterResponse> registerUser(RegisterRequest request);
}

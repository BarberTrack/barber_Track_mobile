import '../entities/register_request.dart';
import '../entities/register_response.dart';
import '../repositories/register_repository.dart';

class RegisterUser {
  final RegisterRepository repository;

  RegisterUser(this.repository);

  Future<RegisterResponse> call(RegisterRequest request) async {
    return await repository.registerUser(request);
  }
}

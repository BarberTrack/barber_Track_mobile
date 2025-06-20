import '../entities/user.dart';
import '../repositories/login_repository.dart';

class AuthenticateUser {
  final LoginRepository repository;

  AuthenticateUser(this.repository);

  Future<User> call({required String email, required String password}) {
    return repository.authenticate(email: email, password: password);
  }
}

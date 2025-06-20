import '../entities/user.dart';

abstract class LoginRepository {
  Future<User> authenticate({required String email, required String password});
}

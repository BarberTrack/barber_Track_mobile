import '../di/injection.dart';
import '../storage/token_storage.dart';

class AuthHelper {
  static TokenStorage get _tokenStorage => sl<TokenStorage>();


  static Future<bool> isLoggedIn() async {
    return await _tokenStorage.isUserLoggedIn();
  }


  static Future<String?> getCurrentToken() async {
    return await _tokenStorage.getToken();
  }


  static Future<void> logout() async {
    await _tokenStorage.logout();
  }


  static Future<bool> hasToken() async {
    return await _tokenStorage.hasToken();
  }
}

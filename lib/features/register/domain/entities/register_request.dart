abstract class RegisterRequest {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String phone;

  const RegisterRequest({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.phone,
  });
}

import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

class RegisterUserEvent extends RegisterEvent {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String phone;

  const RegisterUserEvent({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.phone,
  });

  @override
  List<Object?> get props => [email, password, firstName, lastName, phone];
}

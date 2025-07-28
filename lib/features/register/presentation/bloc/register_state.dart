import 'package:equatable/equatable.dart';
import '../../domain/entities/register_response.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object?> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final RegisterResponse response;

  const RegisterSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class RegisterFailure extends RegisterState {
  final String message;
  final int? statusCode;

  const RegisterFailure(this.message, {this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

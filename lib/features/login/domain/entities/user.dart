import 'package:equatable/equatable.dart';

abstract class User extends Equatable {
  final String accessToken;

  const User({required this.accessToken});

  @override
  List<Object> get props => [accessToken];
}

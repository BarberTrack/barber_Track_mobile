import 'package:equatable/equatable.dart';
import '../../domain/entities/barber.dart';

abstract class BarberHomeState extends Equatable {
  const BarberHomeState();

  @override
  List<Object> get props => [];
}

class BarberHomeInitial extends BarberHomeState {}

class BarberHomeLoading extends BarberHomeState {}

class BarberHomeSuccess extends BarberHomeState {
  final List<Barber> barbers;

  const BarberHomeSuccess(this.barbers);

  @override
  List<Object> get props => [barbers];
}

class BarberHomeError extends BarberHomeState {
  final String message;

  const BarberHomeError(this.message);

  @override
  List<Object> get props => [message];
}

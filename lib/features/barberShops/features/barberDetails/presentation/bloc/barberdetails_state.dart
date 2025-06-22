part of 'barberdetails_bloc.dart';

abstract class BarberdetailsState extends Equatable {
  const BarberdetailsState();

  @override
  List<Object> get props => [];
}

class BarberdetailsInitial extends BarberdetailsState {}

class BarberdetailsLoading extends BarberdetailsState {}

class BarberdetailsLoaded extends BarberdetailsState {
  final BarberBusiness business;

  const BarberdetailsLoaded(this.business);

  @override
  List<Object> get props => [business];
}

class BarberdetailsError extends BarberdetailsState {
  final String message;

  const BarberdetailsError(this.message);

  @override
  List<Object> get props => [message];
}

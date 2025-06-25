part of 'appointments_bloc.dart';

abstract class AppointmentsEvent extends Equatable {
  const AppointmentsEvent();

  @override
  List<Object> get props => [];
}

class LoadAppointments extends AppointmentsEvent {
  final int page;
  final int limit;

  const LoadAppointments({this.page = 1, this.limit = 10});

  @override
  List<Object> get props => [page, limit];
}

class RefreshAppointments extends AppointmentsEvent {
  const RefreshAppointments();
}

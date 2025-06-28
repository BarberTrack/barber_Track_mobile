part of 'appointments_bloc.dart';

abstract class AppointmentsState extends Equatable {
  const AppointmentsState();

  @override
  List<Object?> get props => [];
}

class AppointmentsInitial extends AppointmentsState {}

class AppointmentsLoading extends AppointmentsState {}

class AppointmentsLoaded extends AppointmentsState {
  final List<Appointment> appointments;
  final int total;
  final int page;
  final int totalPages;
  final String? currentFilter;

  const AppointmentsLoaded({
    required this.appointments,
    required this.total,
    required this.page,
    required this.totalPages,
    this.currentFilter,
  });

  @override
  List<Object?> get props => [
    appointments,
    total,
    page,
    totalPages,
    currentFilter,
  ];
}

class AppointmentsError extends AppointmentsState {
  final String message;

  const AppointmentsError(this.message);

  @override
  List<Object> get props => [message];
}

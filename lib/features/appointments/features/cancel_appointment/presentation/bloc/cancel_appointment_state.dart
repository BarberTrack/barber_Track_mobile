import 'package:equatable/equatable.dart';
import '../../../appoinments_home/domain/entities/appointment.dart';

abstract class CancelAppointmentState extends Equatable {
  const CancelAppointmentState();

  @override
  List<Object?> get props => [];
}

class CancelAppointmentInitial extends CancelAppointmentState {}

class CancelAppointmentLoading extends CancelAppointmentState {}

class CancelAppointmentSuccess extends CancelAppointmentState {
  final Appointment updatedAppointment;
  final String message;

  const CancelAppointmentSuccess({
    required this.updatedAppointment,
    required this.message,
  });

  @override
  List<Object> get props => [updatedAppointment, message];
}

class CancelAppointmentError extends CancelAppointmentState {
  final String message;

  const CancelAppointmentError(this.message);

  @override
  List<Object> get props => [message];
}

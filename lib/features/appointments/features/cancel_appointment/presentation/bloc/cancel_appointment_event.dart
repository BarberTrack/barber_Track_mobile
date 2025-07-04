import 'package:equatable/equatable.dart';

abstract class CancelAppointmentEvent extends Equatable {
  const CancelAppointmentEvent();

  @override
  List<Object> get props => [];
}

class CancelAppointmentRequested extends CancelAppointmentEvent {
  final String appointmentId;
  final String reason;

  const CancelAppointmentRequested({
    required this.appointmentId,
    required this.reason,
  });

  @override
  List<Object> get props => [appointmentId, reason];
}

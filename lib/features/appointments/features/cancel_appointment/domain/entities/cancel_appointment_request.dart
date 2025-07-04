import 'package:equatable/equatable.dart';

class CancelAppointmentRequest extends Equatable {
  final String appointmentId;
  final String reason;
  final String cancelledBy;

  const CancelAppointmentRequest({
    required this.appointmentId,
    required this.reason,
    required this.cancelledBy,
  });

  @override
  List<Object> get props => [appointmentId, reason, cancelledBy];
}

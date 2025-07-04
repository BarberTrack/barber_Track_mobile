import 'package:equatable/equatable.dart';
import '../../../appoinments_home/domain/entities/appointment.dart';

class CancelAppointmentResponse extends Equatable {
  final bool success;
  final String message;
  final Appointment data;

  const CancelAppointmentResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  @override
  List<Object> get props => [success, message, data];
}

import 'package:equatable/equatable.dart';
import '../../../appoinments_home/domain/entities/appointment.dart';

class ChangeServiceResponse extends Equatable {
  final bool success;
  final String message;
  final ChangeServiceData data;

  const ChangeServiceResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  @override
  List<Object> get props => [success, message, data];
}

class ChangeServiceData extends Equatable {
  final Appointment appointment;
  final bool updated;
  final Map<String, dynamic> changes;

  const ChangeServiceData({
    required this.appointment,
    required this.updated,
    required this.changes,
  });

  @override
  List<Object> get props => [appointment, updated, changes];
}

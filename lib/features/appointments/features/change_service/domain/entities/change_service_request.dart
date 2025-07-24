import 'package:equatable/equatable.dart';

class ChangeServiceRequest extends Equatable {
  final String scheduledDatetime;
  final String barberId;
  final String serviceId;
  final String? clientNotes;

  const ChangeServiceRequest({
    required this.scheduledDatetime,
    required this.barberId,
    required this.serviceId,
    this.clientNotes,
  });

  @override
  List<Object?> get props => [
    scheduledDatetime,
    barberId,
    serviceId,
    clientNotes,
  ];
}

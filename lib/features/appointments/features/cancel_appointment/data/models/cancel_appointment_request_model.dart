import '../../domain/entities/cancel_appointment_request.dart';

class CancelAppointmentRequestModel {
  final String reason;
  final String cancelledBy;

  const CancelAppointmentRequestModel({
    required this.reason,
    required this.cancelledBy,
  });

  Map<String, dynamic> toJson() {
    return {'reason': reason, 'cancelledBy': cancelledBy};
  }

  factory CancelAppointmentRequestModel.fromEntity(
    CancelAppointmentRequest entity,
  ) {
    return CancelAppointmentRequestModel(
      reason: entity.reason,
      cancelledBy: entity.cancelledBy,
    );
  }
}

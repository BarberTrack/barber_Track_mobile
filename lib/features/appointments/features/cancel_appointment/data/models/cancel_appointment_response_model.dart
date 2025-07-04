import '../../../appoinments_home/data/models/appointments_response_model.dart';

class CancelAppointmentResponseModel {
  final bool success;
  final String message;
  final AppointmentModel data;

  const CancelAppointmentResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CancelAppointmentResponseModel.fromJson(Map<String, dynamic> json) {
    return CancelAppointmentResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: AppointmentModel.fromJson(json['data']),
    );
  }
}

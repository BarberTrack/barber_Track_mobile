import '../entities/cancel_appointment_request.dart';
import '../entities/cancel_appointment_response.dart';

abstract class CancelAppointmentRepository {
  Future<CancelAppointmentResponse> cancelAppointment(
    CancelAppointmentRequest request,
  );
}

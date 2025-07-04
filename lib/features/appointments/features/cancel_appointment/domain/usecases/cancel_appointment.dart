import '../entities/cancel_appointment_request.dart';
import '../entities/cancel_appointment_response.dart';
import '../repositories/cancel_appointment_repository.dart';

class CancelAppointment {
  final CancelAppointmentRepository repository;

  CancelAppointment(this.repository);

  Future<CancelAppointmentResponse> call(
    CancelAppointmentRequest request,
  ) async {
    return await repository.cancelAppointment(request);
  }
}

import '../entities/update_appointment.dart';
import '../repositories/update_appointment_repository.dart';

class UpdateAppointment {
  final UpdateAppointmentRepository repository;

  UpdateAppointment(this.repository);

  Future<UpdateAppointmentResponse> call(UpdateAppointmentRequest request) {
    return repository.updateAppointment(request);
  }
}

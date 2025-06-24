import '../entities/appointment.dart';
import '../repositories/appointment_repository.dart';

class CreateAppointment {
  final AppointmentRepository repository;

  CreateAppointment(this.repository);

  Future<CreateAppointmentResponse> call(CreateAppointmentRequest request) {
    return repository.createAppointment(request);
  }
}

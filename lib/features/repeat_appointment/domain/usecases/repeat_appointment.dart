import '../entities/repeat_appointment.dart';
import '../repositories/repeat_appointment_repository.dart';

class RepeatAppointment {
  final RepeatAppointmentRepository repository;

  RepeatAppointment(this.repository);

  Future<RepeatAppointmentResponse> call(RepeatAppointmentRequest request) {
    return repository.repeatAppointment(request);
  }
}

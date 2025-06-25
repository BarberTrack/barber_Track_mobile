import '../entities/appointment.dart';
import '../repositories/appointments_repository.dart';

class GetAppointments {
  final AppointmentsRepository repository;

  GetAppointments(this.repository);

  Future<AppointmentsResponse> call({int page = 1, int limit = 10}) {
    return repository.getAppointments(page: page, limit: limit);
  }
}

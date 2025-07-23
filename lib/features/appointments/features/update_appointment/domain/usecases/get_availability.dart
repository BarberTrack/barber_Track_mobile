import '../entities/availability.dart';
import '../repositories/update_appointment_repository.dart';

class GetAvailability {
  final UpdateAppointmentRepository repository;

  GetAvailability(this.repository);

  Future<List<Availability>> call({
    required String businessId,
    required String barberId,
    required String serviceId,
    required String date,
    int days = 3,
  }) {
    return repository.getAvailability(
      businessId: businessId,
      barberId: barberId,
      serviceId: serviceId,
      date: date,
      days: days,
    );
  }
}

import '../entities/availability.dart';
import '../repositories/repeat_appointment_repository.dart';

class GetBusinessAvailability {
  final RepeatAppointmentRepository repository;

  GetBusinessAvailability(this.repository);

  Future<AvailabilityResponse> call({
    required String businessId,
    required String barberId,
    required String serviceId,
    required String date,
    int days = 3,
  }) {
    return repository.getBusinessAvailability(
      businessId: businessId,
      barberId: barberId,
      serviceId: serviceId,
      date: date,
      days: days,
    );
  }
}

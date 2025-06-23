import '../entities/availability.dart';
import '../repositories/appointment_repository.dart';

class GetAvailability {
  final AppointmentRepository repository;

  GetAvailability(this.repository);

  Future<List<Availability>> call({
    required String businessId,
    required String barberId,
    required String date,
    int days = 1,
  }) async {
    return await repository.getAvailability(
      businessId: businessId,
      barberId: barberId,
      date: date,
      days: days,
    );
  }
}

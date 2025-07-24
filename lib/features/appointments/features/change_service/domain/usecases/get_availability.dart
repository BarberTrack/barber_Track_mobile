import '../../../create_appointment/domain/entities/availability.dart';
import '../repositories/change_service_repository.dart';

class GetAvailability {
  final ChangeServiceRepository repository;

  GetAvailability(this.repository);

  Future<List<Availability>> call({
    required String businessId,
    required String barberId,
    required String date,
    int days = 1,
  }) {
    return repository.getAvailability(
      businessId: businessId,
      barberId: barberId,
      date: date,
      days: days,
    );
  }
}

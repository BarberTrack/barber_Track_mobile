import '../entities/service.dart';
import '../entities/availability.dart';

abstract class AppointmentRepository {
  Future<List<Service>> getBusinessServices(String businessId);
  Future<List<Availability>> getAvailability({
    required String businessId,
    required String barberId,
    required String date,
    int days = 1,
  });
}

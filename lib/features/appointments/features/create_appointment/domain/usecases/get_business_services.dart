import '../entities/service.dart';
import '../repositories/appointment_repository.dart';

class GetBusinessServices {
  final AppointmentRepository repository;

  GetBusinessServices(this.repository);

  Future<List<Service>> call(String businessId) async {
    return await repository.getBusinessServices(businessId);
  }
}

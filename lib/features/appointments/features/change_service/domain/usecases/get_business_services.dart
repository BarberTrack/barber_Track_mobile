import '../../../create_appointment/domain/entities/service.dart';
import '../repositories/change_service_repository.dart';

class GetBusinessServices {
  final ChangeServiceRepository repository;

  GetBusinessServices(this.repository);

  Future<List<Service>> call(String businessId) {
    return repository.getBusinessServices(businessId);
  }
}

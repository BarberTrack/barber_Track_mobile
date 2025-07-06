import '../entities/business_services_response.dart';
import '../repositories/business_services_repository.dart';

class GetBusinessServices {
  final BusinessServicesRepository repository;

  GetBusinessServices(this.repository);

  Future<BusinessServicesResponse> call(String businessId) async {
    return await repository.getBusinessServices(businessId);
  }
}

import '../entities/business_services_response.dart';

abstract class BusinessServicesRepository {
  Future<BusinessServicesResponse> getBusinessServices(String businessId);
}

import '../entities/business.dart';
import '../entities/business_filters.dart';
import '../entities/businesses_response.dart';

abstract class HomeRepository {
  Future<List<Business>> getBusinesses();
  Future<BusinessesResponse> getBusinessesWithFilters(BusinessFilters filters);
}

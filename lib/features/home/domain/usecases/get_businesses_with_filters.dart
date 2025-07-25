import '../entities/business_filters.dart';
import '../entities/businesses_response.dart';
import '../repositories/home_repository.dart';

class GetBusinessesWithFilters {
  final HomeRepository repository;

  GetBusinessesWithFilters(this.repository);

  Future<BusinessesResponse> call(BusinessFilters filters) async {
    return await repository.getBusinessesWithFilters(filters);
  }
}

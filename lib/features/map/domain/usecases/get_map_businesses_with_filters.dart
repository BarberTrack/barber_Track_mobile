import '../entities/map_business_filters.dart';
import '../entities/map_businesses_response.dart';
import '../repositories/map_repository.dart';

class GetMapBusinessesWithFilters {
  final MapRepository repository;

  GetMapBusinessesWithFilters(this.repository);

  Future<MapBusinessesResponse> call(MapBusinessFilters filters) async {
    return await repository.getBusinessesWithFilters(filters);
  }
}

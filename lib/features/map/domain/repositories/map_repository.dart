import '../entities/map_businesses_response.dart';
import '../entities/map_business_filters.dart';

abstract class MapRepository {
  Future<MapBusinessesResponse> getBusinesses();
  Future<MapBusinessesResponse> getBusinessesWithFilters(
    MapBusinessFilters filters,
  );
}

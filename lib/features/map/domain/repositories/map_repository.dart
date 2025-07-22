import '../entities/map_businesses_response.dart';

abstract class MapRepository {
  Future<MapBusinessesResponse> getBusinesses();
}

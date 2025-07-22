import '../entities/map_businesses_response.dart';
import '../repositories/map_repository.dart';

class GetMapBusinesses {
  final MapRepository repository;

  GetMapBusinesses(this.repository);

  Future<MapBusinessesResponse> call() async {
    return await repository.getBusinesses();
  }
}

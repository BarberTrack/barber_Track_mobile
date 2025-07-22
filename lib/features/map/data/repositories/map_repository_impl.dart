import '../../domain/entities/map_businesses_response.dart';
import '../../domain/repositories/map_repository.dart';
import '../datasources/map_remote_data_source.dart';
import '../mappers/map_business_mapper.dart';

class MapRepositoryImpl implements MapRepository {
  final MapRemoteDataSource remoteDataSource;

  MapRepositoryImpl({required this.remoteDataSource});

  @override
  Future<MapBusinessesResponse> getBusinesses() async {
    try {
      final responseModel = await remoteDataSource.getBusinesses();

      // Mapear modelos a entidades directamente aquí
      final mappedBusinesses = responseModel.businesses
          .map((businessModel) => MapBusinessMapper.toEntity(businessModel))
          .toList();

      return MapBusinessesResponseEntity(
        businesses: mappedBusinesses,
        total: responseModel.total,
        page: responseModel.page,
        totalPages: responseModel.totalPages,
      );
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }
}

// Implementación concreta de la entidad abstracta MapBusinessesResponse
class MapBusinessesResponseEntity extends MapBusinessesResponse {
  const MapBusinessesResponseEntity({
    required super.businesses,
    required super.total,
    required super.page,
    required super.totalPages,
  });
}

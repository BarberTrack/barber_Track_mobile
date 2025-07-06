import '../../domain/entities/business_services_response.dart';
import '../../domain/repositories/business_services_repository.dart';
import '../datasources/business_services_remote_data_source.dart';
import '../mappers/business_services_mapper.dart';

class BusinessServicesRepositoryImpl implements BusinessServicesRepository {
  final BusinessServicesRemoteDataSource remoteDataSource;

  BusinessServicesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<BusinessServicesResponse> getBusinessServices(
    String businessId,
  ) async {
    try {
      final responseModel = await remoteDataSource.getBusinessServices(
        businessId,
      );
      return BusinessServicesMapper.responseModelToEntity(responseModel);
    } catch (e) {
      throw Exception('Error al obtener servicios del negocio: $e');
    }
  }
}

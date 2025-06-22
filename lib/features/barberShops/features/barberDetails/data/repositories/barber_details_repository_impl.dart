import '../../domain/entities/barber_business.dart';
import '../../domain/repositories/barber_details_repository.dart';
import '../datasources/barber_details_remote_data_source.dart';
import '../mappers/barber_business_mapper.dart';

class BarberDetailsRepositoryImpl implements BarberDetailsRepository {
  final BarberDetailsRemoteDataSource remoteDataSource;

  BarberDetailsRepositoryImpl(this.remoteDataSource);

  @override
  Future<BarberBusiness> getBusinessById(String businessId) async {
    try {
      final model = await remoteDataSource.getBusinessById(businessId);
      return BarberBusinessMapper.modelToEntity(model);
    } catch (e) {
      throw Exception('Error en repositorio: $e');
    }
  }
}

import '../../domain/entities/business.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';
import '../mappers/business_mapper.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Business>> getBusinesses() async {
    try {
      final businessModels = await remoteDataSource.getBusinesses();
      // Mapear directamente en el repositorio como especifica el prompt
      return BusinessMapper.modelListToEntityList(businessModels);
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }
}

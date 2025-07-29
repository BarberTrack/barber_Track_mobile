import '../../domain/entities/business.dart';
import '../../domain/entities/business_filters.dart';
import '../../domain/entities/businesses_response.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';
import '../mappers/business_mapper.dart';
import '../mappers/businesses_response_mapper.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Business>> getBusinesses() async {
    try {
      final businessModels = await remoteDataSource.getBusinesses();
      return BusinessMapper.modelListToEntityList(businessModels);
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  @override
  Future<BusinessesResponse> getBusinessesWithFilters(
    BusinessFilters filters,
  ) async {
    try {
      final businessesResponseModel = await remoteDataSource
          .getBusinessesWithFilters(filters);
      return BusinessesResponseMapper.modelToEntity(businessesResponseModel);
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }
}

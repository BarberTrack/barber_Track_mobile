import '../../domain/entities/business_promotions.dart';
import '../../domain/repositories/promotions_repository.dart';
import '../datasources/promotions_remote_data_source.dart';
import '../mappers/business_promotions_mapper.dart';

class PromotionsRepositoryImpl implements PromotionsRepository {
  final PromotionsRemoteDataSource remoteDataSource;

  PromotionsRepositoryImpl(this.remoteDataSource);

  @override
  Future<BusinessPromotions> getBusinessPromotions(String businessId) async {
    try {
      final response = await remoteDataSource.getBusinessPromotions(businessId);
      return response.data.toEntity();
    } catch (e) {
      throw Exception('Error al obtener promociones del negocio: $e');
    }
  }
} 
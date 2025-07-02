import '../../domain/entities/business_review_response.dart';
import '../../domain/repositories/business_review_repository.dart';
import '../datasources/business_review_remote_data_source.dart';
import '../mappers/business_review_mapper.dart';

class BusinessReviewRepositoryImpl implements BusinessReviewRepository {
  final BusinessReviewRemoteDataSource remoteDataSource;

  BusinessReviewRepositoryImpl(this.remoteDataSource);

  @override
  Future<BusinessReviewResponse> getBusinessReviews(
    String businessId, {
    String? status,
  }) async {
    try {
      final model = await remoteDataSource.getBusinessReviews(
        businessId,
        status: status,
      );
      return BusinessReviewMapper.mapBusinessReviewResponseModelToEntity(model);
    } catch (e) {
      throw Exception('Error en repositorio: $e');
    }
  }
}

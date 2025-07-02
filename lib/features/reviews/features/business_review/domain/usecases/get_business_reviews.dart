import '../entities/business_review_response.dart';
import '../repositories/business_review_repository.dart';

class GetBusinessReviews {
  final BusinessReviewRepository repository;

  GetBusinessReviews(this.repository);

  Future<BusinessReviewResponse> call(
    String businessId, {
    String? status,
  }) async {
    return await repository.getBusinessReviews(businessId, status: status);
  }
}

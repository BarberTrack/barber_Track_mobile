import '../entities/business_review_response.dart';

abstract class BusinessReviewRepository {
  Future<BusinessReviewResponse> getBusinessReviews(
    String businessId, {
    String? status,
  });
}

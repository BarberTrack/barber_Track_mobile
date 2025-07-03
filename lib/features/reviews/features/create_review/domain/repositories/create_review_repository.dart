import '../entities/create_review_request.dart';
import '../entities/create_review_response.dart';

abstract class CreateReviewRepository {
  Future<CreateReviewResponse> createReview(CreateReviewRequest request);
}

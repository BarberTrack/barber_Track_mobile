import '../entities/create_review_request.dart';
import '../entities/create_review_response.dart';
import '../repositories/create_review_repository.dart';

class CreateReview {
  final CreateReviewRepository repository;

  CreateReview(this.repository);

  Future<CreateReviewResponse> execute(CreateReviewRequest request) async {
    return await repository.createReview(request);
  }
}

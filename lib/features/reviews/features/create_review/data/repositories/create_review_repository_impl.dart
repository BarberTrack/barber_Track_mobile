import '../../domain/entities/create_review_request.dart';
import '../../domain/entities/create_review_response.dart';
import '../../domain/repositories/create_review_repository.dart';
import '../datasources/create_review_remote_data_source.dart';
import '../mappers/create_review_mapper.dart';
import '../models/create_review_request_model.dart';

class CreateReviewRepositoryImpl implements CreateReviewRepository {
  final CreateReviewRemoteDataSource remoteDataSource;

  CreateReviewRepositoryImpl(this.remoteDataSource);

  @override
  Future<CreateReviewResponse> createReview(CreateReviewRequest request) async {
    final requestModel = CreateReviewRequestModel.fromEntity(request);
    final responseModel = await remoteDataSource.createReview(requestModel);
    return CreateReviewMapper.toEntity(responseModel);
  }
}

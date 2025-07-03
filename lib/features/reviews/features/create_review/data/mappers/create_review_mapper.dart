import '../../domain/entities/create_review_response.dart';
import '../models/create_review_response_model.dart';

class CreateReviewMapper {
  static CreateReviewResponse toEntity(CreateReviewResponseModel model) {
    return CreateReviewResponse(
      success: model.success,
      message: model.message,
      data: _mapReviewData(model.data),
    );
  }

  static ReviewData _mapReviewData(ReviewDataModel model) {
    return ReviewData(
      review: _mapReviewCreated(model.review),
      created: model.created,
      moderationStatus: model.moderationStatus,
      sentimentClassification: model.sentimentClassification,
      moderationReason: model.moderationReason,
    );
  }

  static ReviewCreated _mapReviewCreated(ReviewCreatedModel model) {
    return ReviewCreated(
      id: model.id,
      appointmentId: model.appointmentId,
      clientId: model.clientId,
      businessId: model.businessId,
      barberId: model.barberId,
      userId: model.userId,
      businessRating: model.businessRating,
      barberRating: model.barberRating,
      comment: model.comment,
      status: model.status,
      isFeatured: model.isFeatured,
      businessResponse: model.businessResponse,
      createdAt: DateTime.parse(model.createdAt),
      updatedAt: DateTime.parse(model.updatedAt),
      sentimentClassification: model.sentimentClassification,
      moderationReason: model.moderationReason,
    );
  }
}

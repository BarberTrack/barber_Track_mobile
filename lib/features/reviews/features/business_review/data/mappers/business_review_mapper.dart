import '../models/review_model.dart';
import '../models/business_review_response_model.dart';
import '../models/moderation_logs_model.dart';
import '../../domain/entities/review.dart';
import '../../domain/entities/business_review_response.dart';
import '../../domain/entities/moderation_logs.dart';

class BusinessReviewMapper {
  static Review mapReviewModelToEntity(ReviewModel model) {
    return _ReviewEntity(
      id: model.id,
      appointmentId: model.appointmentId,
      clientId: model.clientId,
      businessId: model.businessId,
      barberId: model.barberId,
      userId: model.userId,
      businessRating: model.businessRating,
      barberRating: model.barberRating,
      comment: model.comment,
      photos: model.photos,
      status: model.status,
      isFeatured: model.isFeatured,
      businessResponse: model.businessResponse,
      moderationLogs: model.moderationLogs != null
          ? mapModerationLogsModelToEntity(model.moderationLogs!)
          : null,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  static BusinessReviewResponse mapBusinessReviewResponseModelToEntity(
    BusinessReviewResponseModel model,
  ) {
    return _BusinessReviewResponseEntity(
      reviews: model.reviews
          .map((reviewModel) => mapReviewModelToEntity(reviewModel))
          .toList(),
      averageRating: model.averageRating,
      totalReviews: model.totalReviews,
    );
  }

  static ModerationLogs mapModerationLogsModelToEntity(
    ModerationLogsModel model,
  ) {
    return _ModerationLogsEntity(
      moderation: model.moderation != null
          ? mapModerationModelToEntity(model.moderation!)
          : null,
    );
  }

  static Moderation mapModerationModelToEntity(ModerationModel model) {
    return _ModerationEntity(action: model.action, reason: model.reason);
  }
}

class _ReviewEntity extends Review {
  const _ReviewEntity({
    required super.id,
    required super.appointmentId,
    required super.clientId,
    required super.businessId,
    required super.barberId,
    super.userId,
    required super.businessRating,
    required super.barberRating,
    required super.comment,
    required super.photos,
    required super.status,
    required super.isFeatured,
    super.businessResponse,
    super.moderationLogs,
    required super.createdAt,
    required super.updatedAt,
  });
}

class _BusinessReviewResponseEntity extends BusinessReviewResponse {
  const _BusinessReviewResponseEntity({
    required super.reviews,
    required super.averageRating,
    required super.totalReviews,
  });
}

class _ModerationLogsEntity extends ModerationLogs {
  const _ModerationLogsEntity({super.moderation});
}

class _ModerationEntity extends Moderation {
  const _ModerationEntity({required super.action, required super.reason});
}

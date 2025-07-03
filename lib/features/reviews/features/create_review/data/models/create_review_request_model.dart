import '../../domain/entities/create_review_request.dart';

class CreateReviewRequestModel {
  final String appointmentId;
  final int businessRating;
  final int barberRating;
  final String comment;

  CreateReviewRequestModel({
    required this.appointmentId,
    required this.businessRating,
    required this.barberRating,
    required this.comment,
  });

  Map<String, dynamic> toJson() {
    return {
      'appointmentId': appointmentId,
      'businessRating': businessRating,
      'barberRating': barberRating,
      'comment': comment,
    };
  }

  factory CreateReviewRequestModel.fromEntity(CreateReviewRequest entity) {
    return CreateReviewRequestModel(
      appointmentId: entity.appointmentId,
      businessRating: entity.businessRating,
      barberRating: entity.barberRating,
      comment: entity.comment,
    );
  }
}

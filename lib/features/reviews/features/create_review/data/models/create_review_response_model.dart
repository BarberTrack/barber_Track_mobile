class CreateReviewResponseModel {
  final bool success;
  final String message;
  final ReviewDataModel data;

  CreateReviewResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CreateReviewResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateReviewResponseModel(
      success: json['success'],
      message: json['message'],
      data: ReviewDataModel.fromJson(json['data']),
    );
  }
}

class ReviewDataModel {
  final ReviewCreatedModel review;
  final bool created;
  final String moderationStatus;
  final String sentimentClassification;
  final String moderationReason;

  ReviewDataModel({
    required this.review,
    required this.created,
    required this.moderationStatus,
    required this.sentimentClassification,
    required this.moderationReason,
  });

  factory ReviewDataModel.fromJson(Map<String, dynamic> json) {
    return ReviewDataModel(
      review: ReviewCreatedModel.fromJson(json['review']),
      created: json['created'],
      moderationStatus: json['moderationStatus'],
      sentimentClassification: json['sentimentClassification'],
      moderationReason: json['moderationReason'],
    );
  }
}

class ReviewCreatedModel {
  final String id;
  final String appointmentId;
  final String clientId;
  final String businessId;
  final String barberId;
  final String userId;
  final int businessRating;
  final int barberRating;
  final String comment;
  final String status;
  final bool isFeatured;
  final String? businessResponse;
  final String createdAt;
  final String updatedAt;
  final String sentimentClassification;
  final String moderationReason;

  ReviewCreatedModel({
    required this.id,
    required this.appointmentId,
    required this.clientId,
    required this.businessId,
    required this.barberId,
    required this.userId,
    required this.businessRating,
    required this.barberRating,
    required this.comment,
    required this.status,
    required this.isFeatured,
    this.businessResponse,
    required this.createdAt,
    required this.updatedAt,
    required this.sentimentClassification,
    required this.moderationReason,
  });

  factory ReviewCreatedModel.fromJson(Map<String, dynamic> json) {
    return ReviewCreatedModel(
      id: json['id'],
      appointmentId: json['appointmentId'],
      clientId: json['clientId'],
      businessId: json['businessId'],
      barberId: json['barberId'],
      userId: json['userId'],
      businessRating: json['businessRating'],
      barberRating: json['barberRating'],
      comment: json['comment'],
      status: json['status'],
      isFeatured: json['isFeatured'],
      businessResponse: json['businessResponse'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      sentimentClassification: json['sentimentClassification'],
      moderationReason: json['moderationReason'],
    );
  }
}

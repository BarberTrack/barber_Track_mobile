import 'package:equatable/equatable.dart';

class CreateReviewResponse extends Equatable {
  final bool success;
  final String message;
  final ReviewData data;

  const CreateReviewResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  @override
  List<Object> get props => [success, message, data];
}

class ReviewData extends Equatable {
  final ReviewCreated review;
  final bool created;
  final String moderationStatus;
  final String sentimentClassification;
  final String moderationReason;

  const ReviewData({
    required this.review,
    required this.created,
    required this.moderationStatus,
    required this.sentimentClassification,
    required this.moderationReason,
  });

  @override
  List<Object> get props => [
    review,
    created,
    moderationStatus,
    sentimentClassification,
    moderationReason,
  ];
}

class ReviewCreated extends Equatable {
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
  final DateTime createdAt;
  final DateTime updatedAt;
  final String sentimentClassification;
  final String moderationReason;

  const ReviewCreated({
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

  @override
  List<Object?> get props => [
    id,
    appointmentId,
    clientId,
    businessId,
    barberId,
    userId,
    businessRating,
    barberRating,
    comment,
    status,
    isFeatured,
    businessResponse,
    createdAt,
    updatedAt,
    sentimentClassification,
    moderationReason,
  ];
}

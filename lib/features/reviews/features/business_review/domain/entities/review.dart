import 'package:equatable/equatable.dart';

abstract class Review extends Equatable {
  final String id;
  final String appointmentId;
  final String clientId;
  final String businessId;
  final String barberId;
  final String? userId;
  final int businessRating;
  final int barberRating;
  final String comment;
  final List<String> photos;
  final String status;
  final bool isFeatured;
  final String? businessResponse;
  final String? moderationLogs;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Review({
    required this.id,
    required this.appointmentId,
    required this.clientId,
    required this.businessId,
    required this.barberId,
    this.userId,
    required this.businessRating,
    required this.barberRating,
    required this.comment,
    required this.photos,
    required this.status,
    required this.isFeatured,
    this.businessResponse,
    this.moderationLogs,
    required this.createdAt,
    required this.updatedAt,
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
    photos,
    status,
    isFeatured,
    businessResponse,
    moderationLogs,
    createdAt,
    updatedAt,
  ];
}

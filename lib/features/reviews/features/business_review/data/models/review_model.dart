class ReviewModel {
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

  ReviewModel({
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

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] ?? '',
      appointmentId: json['appointmentId'] ?? '',
      clientId: json['clientId'] ?? '',
      businessId: json['businessId'] ?? '',
      barberId: json['barberId'] ?? '',
      userId: json['userId'],
      businessRating: json['businessRating'] ?? 0,
      barberRating: json['barberRating'] ?? 0,
      comment: json['comment'] ?? '',
      photos: List<String>.from(json['photos'] ?? []),
      status: json['status'] ?? '',
      isFeatured: json['isFeatured'] ?? false,
      businessResponse: json['businessResponse'],
      moderationLogs: json['moderationLogs'],
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'appointmentId': appointmentId,
      'clientId': clientId,
      'businessId': businessId,
      'barberId': barberId,
      'userId': userId,
      'businessRating': businessRating,
      'barberRating': barberRating,
      'comment': comment,
      'photos': photos,
      'status': status,
      'isFeatured': isFeatured,
      'businessResponse': businessResponse,
      'moderationLogs': moderationLogs,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

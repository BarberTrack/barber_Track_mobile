import '../../../home/data/models/business_model.dart';

class FavoriteModel {
  final String id;
  final String userId;
  final String businessId;
  final DateTime createdAt;
  final DateTime addedAt;
  final BusinessModel business;
  final DateTime? lastVisit;
  final int totalAppointments;

  const FavoriteModel({
    required this.id,
    required this.userId,
    required this.businessId,
    required this.createdAt,
    required this.addedAt,
    required this.business,
    this.lastVisit,
    required this.totalAppointments,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: json['id'],
      userId: json['userId'],
      businessId: json['businessId'],
      createdAt: DateTime.parse(json['createdAt']),
      addedAt: DateTime.parse(json['addedAt']),
      business: BusinessModel.fromJson(json['business']),
      lastVisit: json['lastVisit'] != null
          ? DateTime.parse(json['lastVisit'])
          : null,
      totalAppointments: json['totalAppointments'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'businessId': businessId,
      'createdAt': createdAt.toIso8601String(),
      'addedAt': addedAt.toIso8601String(),
      'business': (business as BusinessModel).toJson(),
      'lastVisit': lastVisit?.toIso8601String(),
      'totalAppointments': totalAppointments,
    };
  }
}

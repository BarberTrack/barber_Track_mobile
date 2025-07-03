import '../../../home/data/models/business_model.dart';

class FavoritesResponseModel {
  final bool success;
  final String message;
  final FavoritesDataModel data;

  FavoritesResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory FavoritesResponseModel.fromJson(Map<String, dynamic> json) {
    return FavoritesResponseModel(
      success: json['success'],
      message: json['message'],
      data: FavoritesDataModel.fromJson(json['data']),
    );
  }
}

class FavoritesDataModel {
  final List<FavoriteModel> favorites;

  FavoritesDataModel({required this.favorites});

  factory FavoritesDataModel.fromJson(Map<String, dynamic> json) {
    return FavoritesDataModel(
      favorites: (json['favorites'] as List)
          .map((favorite) => FavoriteModel.fromJson(favorite))
          .toList(),
    );
  }
}

class FavoriteModel {
  final String id;
  final String userId;
  final String businessId;
  final String createdAt;
  final String addedAt;
  final BusinessModel business;
  final String? lastVisit;
  final int totalAppointments;

  FavoriteModel({
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
      createdAt: json['createdAt'],
      addedAt: json['addedAt'],
      business: BusinessModel.fromJson(json['business']),
      lastVisit: json['lastVisit'],
      totalAppointments: json['totalAppointments'] ?? 0,
    );
  }
}

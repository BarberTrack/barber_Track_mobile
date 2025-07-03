import 'favorite_model.dart';

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

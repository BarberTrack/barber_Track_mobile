import 'favorite_model.dart';

class AddFavoriteResponseModel {
  final bool success;
  final String message;
  final FavoriteModel data;

  const AddFavoriteResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AddFavoriteResponseModel.fromJson(Map<String, dynamic> json) {
    return AddFavoriteResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: FavoriteModel.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': (data as FavoriteModel).toJson(),
    };
  }
}

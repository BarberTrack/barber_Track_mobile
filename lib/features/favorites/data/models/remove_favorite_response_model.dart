class RemoveFavoriteResponseModel {
  final bool success;
  final String message;
  final RemoveFavoriteDataModel data;

  const RemoveFavoriteResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory RemoveFavoriteResponseModel.fromJson(Map<String, dynamic> json) {
    return RemoveFavoriteResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: RemoveFavoriteDataModel.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      // ignore: unnecessary_cast
      'data': (data as RemoveFavoriteDataModel).toJson(),
    };
  }
}

class RemoveFavoriteDataModel {
  final bool removed;
  final String businessId;

  const RemoveFavoriteDataModel({
    required this.removed,
    required this.businessId,
  });

  factory RemoveFavoriteDataModel.fromJson(Map<String, dynamic> json) {
    return RemoveFavoriteDataModel(
      removed: json['removed'] ?? false,
      businessId: json['businessId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'removed': removed, 'businessId': businessId};
  }
}

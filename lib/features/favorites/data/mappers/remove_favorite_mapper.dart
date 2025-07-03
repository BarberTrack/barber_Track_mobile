import '../../domain/entities/remove_favorite_response.dart';
import '../models/remove_favorite_response_model.dart';

class RemoveFavoriteMapper {
  static RemoveFavoriteResponse toEntity(RemoveFavoriteResponseModel model) {
    return RemoveFavoriteResponseEntity(
      success: model.success,
      message: model.message,
      data: RemoveFavoriteDataEntity(
        removed: model.data.removed,
        businessId: model.data.businessId,
      ),
    );
  }
}

class RemoveFavoriteResponseEntity extends RemoveFavoriteResponse {
  const RemoveFavoriteResponseEntity({
    required super.success,
    required super.message,
    required super.data,
  });
}

class RemoveFavoriteDataEntity extends RemoveFavoriteData {
  const RemoveFavoriteDataEntity({
    required super.removed,
    required super.businessId,
  });
}

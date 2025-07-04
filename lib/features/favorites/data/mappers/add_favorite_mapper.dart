import '../../domain/entities/add_favorite_response.dart';
import '../models/add_favorite_response_model.dart';
import 'favorite_mapper.dart';

class AddFavoriteMapper {
  static AddFavoriteResponse toEntity(AddFavoriteResponseModel model) {
    return AddFavoriteResponseEntity(
      success: model.success,
      message: model.message,
      data: FavoriteMapper.toEntity(model.data),
    );
  }
}

class AddFavoriteResponseEntity extends AddFavoriteResponse {
  const AddFavoriteResponseEntity({
    required super.success,
    required super.message,
    required super.data,
  });
}

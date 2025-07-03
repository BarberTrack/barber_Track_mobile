import '../../domain/entities/favorite.dart';
import '../../domain/entities/favorites_response.dart';
import '../models/favorites_response_model.dart';
import '../../../home/data/mappers/business_mapper.dart';

class FavoritesMapper {
  static FavoritesResponse toEntity(FavoritesResponseModel model) {
    return FavoritesResponse(
      success: model.success,
      message: model.message,
      data: _mapFavoritesData(model.data),
    );
  }

  static FavoritesData _mapFavoritesData(FavoritesDataModel model) {
    return FavoritesData(
      favorites: model.favorites
          .map((favoriteModel) => _mapFavorite(favoriteModel))
          .toList(),
    );
  }

  static Favorite _mapFavorite(FavoriteModel model) {
    return FavoriteEntity(
      id: model.id,
      userId: model.userId,
      businessId: model.businessId,
      createdAt: DateTime.parse(model.createdAt),
      addedAt: DateTime.parse(model.addedAt),
      business: BusinessMapper.modelToEntity(model.business),
      lastVisit: model.lastVisit != null
          ? DateTime.parse(model.lastVisit!)
          : null,
      totalAppointments: model.totalAppointments,
    );
  }
}

// Implementación concreta de la entidad abstracta
class FavoriteEntity extends Favorite {
  const FavoriteEntity({
    required super.id,
    required super.userId,
    required super.businessId,
    required super.createdAt,
    required super.addedAt,
    required super.business,
    super.lastVisit,
    required super.totalAppointments,
  });
}

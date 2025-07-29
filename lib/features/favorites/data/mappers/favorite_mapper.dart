// ignore_for_file: unnecessary_cast

import '../../domain/entities/favorite.dart';
import '../models/favorite_model.dart';
import '../../../home/data/mappers/business_mapper.dart';
import '../../../home/data/models/business_model.dart';

class FavoriteMapper {
  static Favorite toEntity(FavoriteModel model) {
    return FavoriteEntity(
      id: model.id,
      userId: model.userId,
      businessId: model.businessId,
      createdAt: model.createdAt,
      addedAt: model.addedAt,
      business: BusinessMapper.modelToEntity(model.business as BusinessModel),
      lastVisit: model.lastVisit,
      totalAppointments: model.totalAppointments,
    );
  }
}


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

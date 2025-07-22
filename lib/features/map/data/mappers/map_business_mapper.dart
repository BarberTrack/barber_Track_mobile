import '../models/map_business_model.dart';
import '../../domain/entities/map_business.dart';

class MapBusinessMapper {
  static MapBusiness toEntity(MapBusinessModel model) {
    return MapBusinessEntity(
      id: model.id,
      ownerId: model.ownerId,
      name: model.name,
      description: model.description,
      address: model.address,
      latitude: model.latitude,
      longitude: model.longitude,
      phone: model.phone,
      email: model.email,
      businessHours: model.businessHours,
      galleryImages: model.galleryImages,
      cancellationPolicy: model.cancellationPolicy,
      breakSettings: model.breakSettings,
      ratingAverage: model.ratingAverage,
      totalReviews: model.totalReviews,
      products: model.products,
      promotions: model.promotions,
      isActive: model.isActive,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  static MapBusinessModel toModel(MapBusiness entity) {
    return MapBusinessModel(
      id: entity.id,
      ownerId: entity.ownerId,
      name: entity.name,
      description: entity.description,
      address: entity.address,
      latitude: entity.latitude,
      longitude: entity.longitude,
      phone: entity.phone,
      email: entity.email,
      businessHours: entity.businessHours,
      galleryImages: entity.galleryImages,
      cancellationPolicy: entity.cancellationPolicy,
      breakSettings: entity.breakSettings,
      ratingAverage: entity.ratingAverage,
      totalReviews: entity.totalReviews,
      products: entity.products,
      promotions: entity.promotions,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}

// Implementación concreta de la entidad abstracta
class MapBusinessEntity extends MapBusiness {
  const MapBusinessEntity({
    required super.id,
    super.ownerId,
    required super.name,
    required super.description,
    required super.address,
    super.latitude,
    super.longitude,
    required super.phone,
    required super.email,
    required super.businessHours,
    required super.galleryImages,
    required super.cancellationPolicy,
    super.breakSettings,
    required super.ratingAverage,
    required super.totalReviews,
    required super.products,
    required super.promotions,
    required super.isActive,
    required super.createdAt,
    required super.updatedAt,
  });
}

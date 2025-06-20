import '../models/business_model.dart';
import '../../domain/entities/business.dart';

class BusinessMapper {
  static Business modelToEntity(BusinessModel model) {
    return BusinessModel(
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

  static List<Business> modelListToEntityList(List<BusinessModel> models) {
    return models.map((model) => modelToEntity(model)).toList();
  }
}

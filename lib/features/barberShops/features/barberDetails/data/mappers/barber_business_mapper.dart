import '../models/barber_business_model.dart';
import '../../domain/entities/barber_business.dart';

class BarberBusinessMapper {
  static BarberBusiness modelToEntity(BarberBusinessModel model) {
    return BarberBusiness(
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
}

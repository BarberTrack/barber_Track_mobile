import '../../../../../home/domain/entities/business.dart';

class BarberBusiness extends Business {
  const BarberBusiness({
    required super.id,
    required super.ownerId,
    required super.name,
    required super.description,
    required super.address,
    required super.latitude,
    required super.longitude,
    required super.phone,
    required super.email,
    required super.businessHours,
    required super.galleryImages,
    required super.cancellationPolicy,
    required super.breakSettings,
    required super.ratingAverage,
    required super.totalReviews,
    required super.products,
    required super.promotions,
    required super.isActive,
    required super.createdAt,
    required super.updatedAt,
  });
}

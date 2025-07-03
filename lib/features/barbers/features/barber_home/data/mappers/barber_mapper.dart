import '../models/barber_model.dart';
import '../../domain/entities/barber.dart';

class BarberMapper {
  static Barber toEntity(BarberModel model) {
    return _BarberImpl(
      id: model.id,
      businessId: model.businessId,
      firstName: model.firstName,
      lastName: model.lastName,
      bio: model.bio,
      specialties: model.specialties,
      workSchedule: model.workSchedule,
      portfolioImages: model.portfolioImages,
      yearsExperience: model.yearsExperience,
      ratingAverage: model.ratingAverage,
      totalReviews: model.totalReviews,
      isActive: model.isActive,
    );
  }

  static List<Barber> toEntityList(List<BarberModel> models) {
    return models.map((model) => toEntity(model)).toList();
  }
}

class _BarberImpl extends Barber {
  const _BarberImpl({
    required super.id,
    required super.businessId,
    required super.firstName,
    required super.lastName,
    required super.bio,
    required super.specialties,
    required super.workSchedule,
    super.portfolioImages,
    required super.yearsExperience,
    required super.ratingAverage,
    required super.totalReviews,
    required super.isActive,
  });
}

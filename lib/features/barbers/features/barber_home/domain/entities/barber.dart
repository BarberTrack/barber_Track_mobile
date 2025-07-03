abstract class Barber {
  final String id;
  final String businessId;
  final String firstName;
  final String lastName;
  final String bio;
  final List<String> specialties;
  final Map<String, dynamic> workSchedule;
  final List<String>? portfolioImages;
  final int yearsExperience;
  final String ratingAverage;
  final int totalReviews;
  final bool isActive;

  const Barber({
    required this.id,
    required this.businessId,
    required this.firstName,
    required this.lastName,
    required this.bio,
    required this.specialties,
    required this.workSchedule,
    this.portfolioImages,
    required this.yearsExperience,
    required this.ratingAverage,
    required this.totalReviews,
    required this.isActive,
  });

  String get fullName => '$firstName $lastName';
}

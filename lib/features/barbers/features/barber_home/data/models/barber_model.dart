class BarberModel {
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
  final String createdAt;
  final String updatedAt;

  BarberModel({
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
    required this.createdAt,
    required this.updatedAt,
  });

  factory BarberModel.fromJson(Map<String, dynamic> json) {
    return BarberModel(
      id: json['id'] ?? '',
      businessId: json['businessId'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      bio: json['bio'] ?? '',
      specialties:
          (json['specialties'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      workSchedule: json['workSchedule'] ?? {},
      portfolioImages: (json['portfolioImages'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      yearsExperience: json['yearsExperience'] ?? 0,
      ratingAverage: json['ratingAverage'] ?? '0.00',
      totalReviews: json['totalReviews'] ?? 0,
      isActive: json['isActive'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'businessId': businessId,
      'firstName': firstName,
      'lastName': lastName,
      'bio': bio,
      'specialties': specialties,
      'workSchedule': workSchedule,
      'portfolioImages': portfolioImages,
      'yearsExperience': yearsExperience,
      'ratingAverage': ratingAverage,
      'totalReviews': totalReviews,
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class BarberBusinessModel {
  final String id;
  final String ownerId;
  final String name;
  final String description;
  final String address;
  final double latitude;
  final double longitude;
  final String phone;
  final String email;
  final Map<String, dynamic> businessHours;
  final List<String> galleryImages;
  final Map<String, dynamic> cancellationPolicy;
  final Map<String, dynamic> breakSettings;
  final double ratingAverage;
  final int totalReviews;
  final List<Map<String, dynamic>> products;
  final List<Map<String, dynamic>> promotions;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BarberBusinessModel({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.description,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.phone,
    required this.email,
    required this.businessHours,
    required this.galleryImages,
    required this.cancellationPolicy,
    required this.breakSettings,
    required this.ratingAverage,
    required this.totalReviews,
    required this.products,
    required this.promotions,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BarberBusinessModel.fromJson(Map<String, dynamic> json) {
    return BarberBusinessModel(
      id: json['id'] ?? '',
      ownerId: json['ownerId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      businessHours: json['businessHours'] ?? {},
      galleryImages: List<String>.from(json['galleryImages'] ?? []),
      cancellationPolicy: json['cancellationPolicy'] ?? {},
      breakSettings: json['breakSettings'] ?? {},
      ratingAverage: (json['ratingAverage'] ?? 0.0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      products: List<Map<String, dynamic>>.from(json['products'] ?? []),
      promotions: List<Map<String, dynamic>>.from(json['promotions'] ?? []),
      isActive: json['isActive'] ?? false,
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}

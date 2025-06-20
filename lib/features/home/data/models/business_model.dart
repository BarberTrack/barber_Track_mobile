import '../../domain/entities/business.dart';

class BusinessModel extends Business {
  const BusinessModel({
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

  factory BusinessModel.fromJson(Map<String, dynamic> json) {
    return BusinessModel(
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerId': ownerId,
      'name': name,
      'description': description,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'phone': phone,
      'email': email,
      'businessHours': businessHours,
      'galleryImages': galleryImages,
      'cancellationPolicy': cancellationPolicy,
      'breakSettings': breakSettings,
      'ratingAverage': ratingAverage,
      'totalReviews': totalReviews,
      'products': products,
      'promotions': promotions,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

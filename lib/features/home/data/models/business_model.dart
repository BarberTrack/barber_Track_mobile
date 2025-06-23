import '../../domain/entities/business.dart';

class BusinessModel extends Business {
  const BusinessModel({
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

  factory BusinessModel.fromJson(Map<String, dynamic> json) {
    return BusinessModel(
      id: json['id'] ?? '',
      ownerId: json['ownerId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      businessHours: json['businessHours'] ?? {},
      galleryImages: _parseGalleryImages(json['galleryImages']),
      cancellationPolicy: json['cancellationPolicy'] ?? {},
      breakSettings: json['breakSettings'] ?? {},
      ratingAverage: _parseRatingAverage(json['ratingAverage']),
      totalReviews: json['totalReviews'] ?? 0,
      products: _parseProducts(json['products']),
      promotions: _parsePromotions(json['promotions']),
      isActive: json['isActive'] ?? false,
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  static List<String> _parseGalleryImages(dynamic galleryImages) {
    if (galleryImages == null) return [];
    if (galleryImages is List) {
      return galleryImages
          .map((item) {
            if (item is Map<String, dynamic> && item['url'] != null) {
              return item['url'].toString();
            }
            return item.toString();
          })
          .where((url) => url.isNotEmpty)
          .toList();
    }
    return [];
  }

  static double _parseRatingAverage(dynamic ratingAverage) {
    if (ratingAverage == null) return 0.0;
    if (ratingAverage is String) {
      return double.tryParse(ratingAverage) ?? 0.0;
    }
    if (ratingAverage is num) {
      return ratingAverage.toDouble();
    }
    return 0.0;
  }

  static List<Map<String, dynamic>> _parseProducts(dynamic products) {
    if (products == null) return [];
    if (products is List) {
      return products.whereType<Map<String, dynamic>>().toList();
    }
    return [];
  }

  static List<Map<String, dynamic>> _parsePromotions(dynamic promotions) {
    if (promotions == null) return [];
    if (promotions is List) {
      return promotions.whereType<Map<String, dynamic>>().toList();
    }
    return [];
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

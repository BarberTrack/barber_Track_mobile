import 'package:equatable/equatable.dart';

abstract class MapBusiness extends Equatable {
  final String id;
  final String? ownerId;
  final String name;
  final String description;
  final String address;
  final double? latitude;
  final double? longitude;
  final String phone;
  final String email;
  final Map<String, dynamic> businessHours;
  final List<String> galleryImages;
  final Map<String, dynamic> cancellationPolicy;
  final Map<String, dynamic>? breakSettings;
  final double ratingAverage;
  final int totalReviews;
  final List<Map<String, dynamic>> products;
  final List<Map<String, dynamic>> promotions;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MapBusiness({
    required this.id,
    this.ownerId,
    required this.name,
    required this.description,
    required this.address,
    this.latitude,
    this.longitude,
    required this.phone,
    required this.email,
    required this.businessHours,
    required this.galleryImages,
    required this.cancellationPolicy,
    this.breakSettings,
    required this.ratingAverage,
    required this.totalReviews,
    required this.products,
    required this.promotions,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    ownerId,
    name,
    description,
    address,
    latitude,
    longitude,
    phone,
    email,
    businessHours,
    galleryImages,
    cancellationPolicy,
    breakSettings,
    ratingAverage,
    totalReviews,
    products,
    promotions,
    isActive,
    createdAt,
    updatedAt,
  ];
}

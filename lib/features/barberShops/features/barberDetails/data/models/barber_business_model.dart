class BarberBusinessModel {
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
  final List<String>? galleryImages;
  final Map<String, dynamic> cancellationPolicy;
  final Map<String, dynamic>? breakSettings;
  final double ratingAverage;
  final int totalReviews;
  final List<Map<String, dynamic>>? products;
  final List<Map<String, dynamic>>? promotions;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BarberBusinessModel({
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
    this.galleryImages,
    required this.cancellationPolicy,
    this.breakSettings,
    required this.ratingAverage,
    required this.totalReviews,
    this.products,
    this.promotions,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BarberBusinessModel.fromJson(Map<String, dynamic> json) {
    // Helper para convertir ratingAverage que puede venir como String o double
    double parseRatingAverage(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    // Helper para convertir latitude/longitude que pueden ser null
    double? parseCoordinate(dynamic value) {
      if (value == null) return null;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    // Helper para manejar Map de forma segura
    Map<String, dynamic> parseMap(dynamic value) {
      if (value == null) return {};
      if (value is Map<String, dynamic>) return value;
      if (value is Map) return Map<String, dynamic>.from(value);
      return {};
    }

    // Helper para manejar String de forma segura
    String parseString(dynamic value) {
      if (value == null) return '';
      if (value is String) return value;
      return value.toString();
    }

    // Helper para manejar bool de forma segura
    bool parseBool(dynamic value) {
      if (value == null) return false;
      if (value is bool) return value;
      if (value is String) return value.toLowerCase() == 'true';
      if (value is int) return value != 0;
      return false;
    }

    // Helper para manejar int de forma segura
    int parseInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    try {
      final id = parseString(json['id']);
      final ownerId = json['ownerId'] is String ? json['ownerId'] : null;
      final name = parseString(json['name']);
      final description = parseString(json['description']);
      final address = parseString(json['address']);
      final latitude = parseCoordinate(json['latitude']);
      final longitude = parseCoordinate(json['longitude']);
      final phone = parseString(json['phone']);
      final email = parseString(json['email']);
      final businessHours = parseMap(json['businessHours']);

      List<String>? galleryImages;
      if (json['galleryImages'] != null) {
        try {
          if (json['galleryImages'] is List) {
            List<dynamic> imagesData = json['galleryImages'] as List;
            galleryImages = imagesData
                .map((item) {
                  if (item is String) {
                    // Si ya es un String, lo devolvemos tal como está
                    return item;
                  } else if (item is Map<String, dynamic>) {
                    // Si es un objeto, intentamos extraer la URL
                    // Posibles campos: url, imageUrl, path, src, etc.
                    return item['url'] ??
                        item['imageUrl'] ??
                        item['path'] ??
                        item['src'] ??
                        item['link'] ??
                        '';
                  } else {
                    // Si es otro tipo, lo convertimos a String
                    return item.toString();
                  }
                })
                .where((url) => url.isNotEmpty)
                .toList()
                .cast<String>();
          }
        } catch (e) {
          print('Warning: Error parsing galleryImages: $e');
          print('galleryImages data: ${json['galleryImages']}');
          galleryImages = [];
        }
      }

      final cancellationPolicy = parseMap(json['cancellationPolicy']);
      final breakSettings = json['breakSettings'] != null
          ? parseMap(json['breakSettings'])
          : null;
      final ratingAverage = parseRatingAverage(json['ratingAverage']);
      final totalReviews = parseInt(json['totalReviews']);

      List<Map<String, dynamic>>? products;
      if (json['products'] != null) {
        try {
          if (json['products'] is List) {
            products = List<Map<String, dynamic>>.from(json['products']);
          }
        } catch (e) {
          print('Warning: Error parsing products: $e');
          products = null;
        }
      }

      List<Map<String, dynamic>>? promotions;
      if (json['promotions'] != null) {
        try {
          if (json['promotions'] is List) {
            promotions = List<Map<String, dynamic>>.from(json['promotions']);
          }
        } catch (e) {
          print('Warning: Error parsing promotions: $e');
          promotions = null;
        }
      }

      final isActive = parseBool(json['isActive']);
      final createdAt = DateTime.parse(
        parseString(json['createdAt']).isNotEmpty
            ? json['createdAt']
            : DateTime.now().toIso8601String(),
      );
      final updatedAt = DateTime.parse(
        parseString(json['updatedAt']).isNotEmpty
            ? json['updatedAt']
            : DateTime.now().toIso8601String(),
      );

      return BarberBusinessModel(
        id: id,
        ownerId: ownerId,
        name: name,
        description: description,
        address: address,
        latitude: latitude,
        longitude: longitude,
        phone: phone,
        email: email,
        businessHours: businessHours,
        galleryImages: galleryImages,
        cancellationPolicy: cancellationPolicy,
        breakSettings: breakSettings,
        ratingAverage: ratingAverage,
        totalReviews: totalReviews,
        products: products,
        promotions: promotions,
        isActive: isActive,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
    } catch (e) {
      print('ERROR: Error in BarberBusinessModel.fromJson: $e');
      print('JSON input: $json');
      rethrow;
    }
  }
}

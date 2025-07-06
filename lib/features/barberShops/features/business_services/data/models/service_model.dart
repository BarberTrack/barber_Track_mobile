class ServiceModel {
  final String id;
  final String businessId;
  final String name;
  final String description;
  final String price;
  final int durationMinutes;
  final String? imageUrl;
  final bool isActive;
  final List<BarberAssignmentModel> barberAssignments;
  final String createdAt;
  final String updatedAt;

  ServiceModel({
    required this.id,
    required this.businessId,
    required this.name,
    required this.description,
    required this.price,
    required this.durationMinutes,
    this.imageUrl,
    required this.isActive,
    required this.barberAssignments,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] ?? '',
      businessId: json['businessId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? '0.00',
      durationMinutes: json['durationMinutes'] ?? 0,
      imageUrl: json['imageUrl'],
      isActive: json['isActive'] ?? false,
      barberAssignments:
          (json['barberAssignments'] as List?)
              ?.map((e) => BarberAssignmentModel.fromJson(e))
              .toList() ??
          [],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'businessId': businessId,
      'name': name,
      'description': description,
      'price': price,
      'durationMinutes': durationMinutes,
      'imageUrl': imageUrl,
      'isActive': isActive,
      'barberAssignments': barberAssignments.map((e) => e.toJson()).toList(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class BarberAssignmentModel {
  final String barberId;
  final bool isPreferred;
  final double specialPrice;
  final String firstName;
  final String lastName;

  BarberAssignmentModel({
    required this.barberId,
    required this.isPreferred,
    required this.specialPrice,
    required this.firstName,
    required this.lastName,
  });

  factory BarberAssignmentModel.fromJson(Map<String, dynamic> json) {
    return BarberAssignmentModel(
      barberId: json['barberId'] ?? '',
      isPreferred: json['isPreferred'] ?? false,
      specialPrice: (json['specialPrice'] ?? 0).toDouble(),
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'barberId': barberId,
      'isPreferred': isPreferred,
      'specialPrice': specialPrice,
      'first_name': firstName,
      'last_name': lastName,
    };
  }
}

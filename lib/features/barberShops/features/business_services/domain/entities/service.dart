class Service {
  final String id;
  final String businessId;
  final String name;
  final String description;
  final String price;
  final int durationMinutes;
  final String? imageUrl;
  final bool isActive;
  final List<BarberAssignment> barberAssignments;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Service({
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
}

class BarberAssignment {
  final String barberId;
  final bool isPreferred;
  final double specialPrice;
  final String firstName;
  final String lastName;

  const BarberAssignment({
    required this.barberId,
    required this.isPreferred,
    required this.specialPrice,
    required this.firstName,
    required this.lastName,
  });
}

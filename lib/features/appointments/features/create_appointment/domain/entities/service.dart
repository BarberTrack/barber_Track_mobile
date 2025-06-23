import 'package:equatable/equatable.dart';
import 'barber_assignment.dart';

class Service extends Equatable {
  final String id;
  final String businessId;
  final String name;
  final String description;
  final double price;
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

  @override
  List<Object?> get props => [
    id,
    businessId,
    name,
    description,
    price,
    durationMinutes,
    imageUrl,
    isActive,
    barberAssignments,
    createdAt,
    updatedAt,
  ];
}

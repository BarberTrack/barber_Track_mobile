import 'package:equatable/equatable.dart';
import '../../../home/domain/entities/business.dart';

abstract class Favorite extends Equatable {
  final String id;
  final String userId;
  final String businessId;
  final DateTime createdAt;
  final DateTime addedAt;
  final Business business;
  final DateTime? lastVisit;
  final int totalAppointments;

  const Favorite({
    required this.id,
    required this.userId,
    required this.businessId,
    required this.createdAt,
    required this.addedAt,
    required this.business,
    this.lastVisit,
    required this.totalAppointments,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    businessId,
    createdAt,
    addedAt,
    business,
    lastVisit,
    totalAppointments,
  ];
}

import 'package:equatable/equatable.dart';

class BarberAssignment extends Equatable {
  final String barberId;
  final bool isPreferred;
  final double? specialPrice;

  const BarberAssignment({
    required this.barberId,
    required this.isPreferred,
    this.specialPrice,
  });

  @override
  List<Object?> get props => [barberId, isPreferred, specialPrice];
}

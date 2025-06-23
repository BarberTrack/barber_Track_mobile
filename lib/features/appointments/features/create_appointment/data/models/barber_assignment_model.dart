class BarberAssignmentModel {
  final String barberId;
  final bool isPreferred;
  final double? specialPrice;

  const BarberAssignmentModel({
    required this.barberId,
    required this.isPreferred,
    this.specialPrice,
  });

  factory BarberAssignmentModel.fromJson(Map<String, dynamic> json) {
    // Helper para parsear precio especial que puede venir como String o número
    double? parseSpecialPrice(dynamic value) {
      if (value == null) return null;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    return BarberAssignmentModel(
      barberId: json['barberId'] ?? '',
      isPreferred: json['isPreferred'] ?? false,
      specialPrice: parseSpecialPrice(json['specialPrice']),
    );
  }
}

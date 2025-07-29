class PromotionModel {
  final String id;
  final String title;
  final String description;
  final String discountType;
  final double discountValue;
  final DateTime validFrom;
  final DateTime validTo;
  final bool isActive;
  final PromotionConditionsModel conditions;

  PromotionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.discountType,
    required this.discountValue,
    required this.validFrom,
    required this.validTo,
    required this.isActive,
    required this.conditions,
  });

  factory PromotionModel.fromJson(Map<String, dynamic> json) {
    return PromotionModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      discountType: json['discountType'] ?? 'percentage',
      discountValue: (json['discountValue'] ?? 0).toDouble(),
      validFrom: DateTime.parse(json['validFrom'] ?? DateTime.now().toIso8601String()),
      validTo: DateTime.parse(json['validTo'] ?? DateTime.now().toIso8601String()),
      isActive: json['isActive'] ?? false,
      conditions: PromotionConditionsModel.fromJson(json['conditions'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'discountType': discountType,
      'discountValue': discountValue,
      'validFrom': validFrom.toIso8601String(),
      'validTo': validTo.toIso8601String(),
      'isActive': isActive,
      'conditions': conditions.toJson(),
    };
  }
}

class PromotionConditionsModel {
  final double minAmount;

  PromotionConditionsModel({
    required this.minAmount,
  });

  factory PromotionConditionsModel.fromJson(Map<String, dynamic> json) {
    return PromotionConditionsModel(
      minAmount: (json['minAmount'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'minAmount': minAmount,
    };
  }
} 
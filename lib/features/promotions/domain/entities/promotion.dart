abstract class Promotion {
  final String id;
  final String title;
  final String description;
  final String discountType;
  final double discountValue;
  final DateTime validFrom;
  final DateTime validTo;
  final bool isActive;
  final PromotionConditions conditions;

  const Promotion({
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
}

abstract class PromotionConditions {
  final double minAmount;

  const PromotionConditions({
    required this.minAmount,
  });
} 
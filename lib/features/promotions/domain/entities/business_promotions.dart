import 'promotion.dart';

abstract class BusinessPromotions {
  final String businessId;
  final List<Promotion> promotions;

  const BusinessPromotions({
    required this.businessId,
    required this.promotions,
  });
} 
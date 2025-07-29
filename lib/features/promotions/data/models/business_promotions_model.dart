import 'promotion_model.dart';

class BusinessPromotionsModel {
  final String businessId;
  final List<PromotionModel> promotions;

  BusinessPromotionsModel({
    required this.businessId,
    required this.promotions,
  });

  factory BusinessPromotionsModel.fromJson(Map<String, dynamic> json) {
    return BusinessPromotionsModel(
      businessId: json['id'] ?? '',
      promotions: (json['promotions'] as List<dynamic>? ?? [])
          .map((promotion) => PromotionModel.fromJson(promotion as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': businessId,
      'promotions': promotions.map((promotion) => promotion.toJson()).toList(),
    };
  }
} 
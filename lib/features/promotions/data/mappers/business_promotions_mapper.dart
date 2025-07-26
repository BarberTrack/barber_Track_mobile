import '../../domain/entities/business_promotions.dart';
import '../models/business_promotions_model.dart';
import 'promotion_mapper.dart';

class BusinessPromotionsEntity extends BusinessPromotions {
  const BusinessPromotionsEntity({
    required super.businessId,
    required super.promotions,
  });
}

extension BusinessPromotionsModelMapper on BusinessPromotionsModel {
  BusinessPromotions toEntity() {
    return BusinessPromotionsEntity(
      businessId: businessId,
      promotions: promotions.map((promotion) => promotion.toEntity()).toList(),
    );
  }
} 
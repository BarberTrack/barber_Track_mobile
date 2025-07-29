import '../../domain/entities/promotion.dart';
import '../models/promotion_model.dart';

class PromotionEntity extends Promotion {
  const PromotionEntity({
    required super.id,
    required super.title,
    required super.description,
    required super.discountType,
    required super.discountValue,
    required super.validFrom,
    required super.validTo,
    required super.isActive,
    required super.conditions,
  });
}

class PromotionConditionsEntity extends PromotionConditions {
  const PromotionConditionsEntity({
    required super.minAmount,
  });
}

extension PromotionModelMapper on PromotionModel {
  Promotion toEntity() {
    return PromotionEntity(
      id: id,
      title: title,
      description: description,
      discountType: discountType,
      discountValue: discountValue,
      validFrom: validFrom,
      validTo: validTo,
      isActive: isActive,
      conditions: conditions.toEntity(),
    );
  }
}

extension PromotionConditionsModelMapper on PromotionConditionsModel {
  PromotionConditions toEntity() {
    return PromotionConditionsEntity(
      minAmount: minAmount,
    );
  }
} 
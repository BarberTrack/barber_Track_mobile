import '../entities/business_promotions.dart';

abstract class PromotionsRepository {
  Future<BusinessPromotions> getBusinessPromotions(String businessId);
} 
import '../entities/business_promotions.dart';
import '../repositories/promotions_repository.dart';

class GetBusinessPromotions {
  final PromotionsRepository repository;

  GetBusinessPromotions(this.repository);

  Future<BusinessPromotions> call(String businessId) {
    return repository.getBusinessPromotions(businessId);
  }
} 
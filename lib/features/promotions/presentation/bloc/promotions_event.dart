abstract class PromotionsEvent {
  const PromotionsEvent();
}

class LoadBusinessPromotions extends PromotionsEvent {
  final String businessId;

  const LoadBusinessPromotions(this.businessId);
}

import '../../domain/entities/business_promotions.dart';

abstract class PromotionsState {
  const PromotionsState();
}

class PromotionsInitial extends PromotionsState {
  const PromotionsInitial();
}

class PromotionsLoading extends PromotionsState {
  const PromotionsLoading();
}

class PromotionsLoaded extends PromotionsState {
  final BusinessPromotions businessPromotions;

  const PromotionsLoaded(this.businessPromotions);
}

class PromotionsError extends PromotionsState {
  final String message;

  const PromotionsError(this.message);
}

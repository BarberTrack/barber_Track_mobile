import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_business_promotions.dart';
import 'promotions_event.dart';
import 'promotions_state.dart';

class PromotionsBloc extends Bloc<PromotionsEvent, PromotionsState> {
  final GetBusinessPromotions getBusinessPromotions;

  PromotionsBloc({
    required this.getBusinessPromotions,
  }) : super(const PromotionsInitial()) {
    on<LoadBusinessPromotions>(_onLoadBusinessPromotions);
  }

  Future<void> _onLoadBusinessPromotions(
    LoadBusinessPromotions event,
    Emitter<PromotionsState> emit,
  ) async {
    emit(const PromotionsLoading());

    try {
      final businessPromotions = await getBusinessPromotions(event.businessId);
      emit(PromotionsLoaded(businessPromotions));
    } catch (e) {
      emit(PromotionsError(e.toString()));
    }
  }
}

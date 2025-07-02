import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/business_review_response.dart';
import '../../domain/usecases/get_business_reviews.dart';

part 'business_review_event.dart';
part 'business_review_state.dart';

class BusinessReviewBloc
    extends Bloc<BusinessReviewEvent, BusinessReviewState> {
  final GetBusinessReviews getBusinessReviews;

  BusinessReviewBloc(this.getBusinessReviews) : super(BusinessReviewInitial()) {
    on<LoadBusinessReviews>(_onLoadBusinessReviews);
    on<RefreshBusinessReviews>(_onRefreshBusinessReviews);
    on<FilterBusinessReviews>(_onFilterBusinessReviews);
  }

  Future<void> _onLoadBusinessReviews(
    LoadBusinessReviews event,
    Emitter<BusinessReviewState> emit,
  ) async {
    emit(BusinessReviewLoading());
    try {
      final reviewResponse = await getBusinessReviews(
        event.businessId,
        status: event.status,
      );
      emit(BusinessReviewLoaded(reviewResponse));
    } catch (e) {
      emit(BusinessReviewError('Error al cargar las reseñas: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshBusinessReviews(
    RefreshBusinessReviews event,
    Emitter<BusinessReviewState> emit,
  ) async {
    try {
      final reviewResponse = await getBusinessReviews(
        event.businessId,
        status: event.status,
      );
      emit(BusinessReviewLoaded(reviewResponse));
    } catch (e) {
      emit(
        BusinessReviewError('Error al actualizar las reseñas: ${e.toString()}'),
      );
    }
  }

  Future<void> _onFilterBusinessReviews(
    FilterBusinessReviews event,
    Emitter<BusinessReviewState> emit,
  ) async {
    emit(BusinessReviewLoading());
    try {
      final reviewResponse = await getBusinessReviews(
        event.businessId,
        status: event.status,
      );
      emit(BusinessReviewLoaded(reviewResponse));
    } catch (e) {
      emit(
        BusinessReviewError('Error al filtrar las reseñas: ${e.toString()}'),
      );
    }
  }
}

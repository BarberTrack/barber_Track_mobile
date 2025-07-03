import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/create_review_request.dart';
import '../../domain/usecases/create_review.dart';
import 'create_review_event.dart';
import 'create_review_state.dart';

class CreateReviewBloc extends Bloc<CreateReviewEvent, CreateReviewState> {
  final CreateReview createReviewUseCase;

  CreateReviewBloc({required this.createReviewUseCase})
    : super(CreateReviewInitial()) {
    on<SubmitReviewEvent>(_onSubmitReview);
  }

  Future<void> _onSubmitReview(
    SubmitReviewEvent event,
    Emitter<CreateReviewState> emit,
  ) async {
    emit(CreateReviewLoading());

    try {
      final request = CreateReviewRequest(
        appointmentId: event.appointmentId,
        businessRating: event.businessRating,
        barberRating: event.barberRating,
        comment: event.comment,
      );

      final response = await createReviewUseCase.execute(request);
      emit(CreateReviewSuccess(response));
    } catch (e) {
      emit(CreateReviewError(e.toString()));
    }
  }
}

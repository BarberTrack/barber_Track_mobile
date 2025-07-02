part of 'business_review_bloc.dart';

abstract class BusinessReviewState extends Equatable {
  const BusinessReviewState();

  @override
  List<Object> get props => [];
}

class BusinessReviewInitial extends BusinessReviewState {}

class BusinessReviewLoading extends BusinessReviewState {}

class BusinessReviewLoaded extends BusinessReviewState {
  final BusinessReviewResponse reviewResponse;

  const BusinessReviewLoaded(this.reviewResponse);

  @override
  List<Object> get props => [reviewResponse];
}

class BusinessReviewError extends BusinessReviewState {
  final String message;

  const BusinessReviewError(this.message);

  @override
  List<Object> get props => [message];
}

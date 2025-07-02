part of 'business_review_bloc.dart';

abstract class BusinessReviewEvent extends Equatable {
  const BusinessReviewEvent();

  @override
  List<Object?> get props => [];
}

class LoadBusinessReviews extends BusinessReviewEvent {
  final String businessId;
  final String? status;

  const LoadBusinessReviews(this.businessId, {this.status});

  @override
  List<Object?> get props => [businessId, status];
}

class RefreshBusinessReviews extends BusinessReviewEvent {
  final String businessId;
  final String? status;

  const RefreshBusinessReviews(this.businessId, {this.status});

  @override
  List<Object?> get props => [businessId, status];
}

class FilterBusinessReviews extends BusinessReviewEvent {
  final String businessId;
  final String? status;

  const FilterBusinessReviews(this.businessId, this.status);

  @override
  List<Object?> get props => [businessId, status];
}

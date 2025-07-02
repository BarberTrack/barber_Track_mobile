import 'package:equatable/equatable.dart';
import 'review.dart';

abstract class BusinessReviewResponse extends Equatable {
  final List<Review> reviews;
  final double averageRating;
  final int totalReviews;

  const BusinessReviewResponse({
    required this.reviews,
    required this.averageRating,
    required this.totalReviews,
  });

  @override
  List<Object?> get props => [reviews, averageRating, totalReviews];
}

import 'review_model.dart';

class BusinessReviewResponseModel {
  final List<ReviewModel> reviews;
  final double averageRating;
  final int totalReviews;

  BusinessReviewResponseModel({
    required this.reviews,
    required this.averageRating,
    required this.totalReviews,
  });

  factory BusinessReviewResponseModel.fromJson(Map<String, dynamic> json) {
    final dataMap = json['data'] ?? {};
    return BusinessReviewResponseModel(
      reviews:
          (dataMap['reviews'] as List<dynamic>?)
              ?.map((reviewJson) => ReviewModel.fromJson(reviewJson))
              .toList() ??
          [],
      averageRating: (dataMap['averageRating'] ?? 0.0).toDouble(),
      totalReviews: dataMap['totalReviews'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': {
        'reviews': reviews.map((review) => review.toJson()).toList(),
        'averageRating': averageRating,
        'totalReviews': totalReviews,
      },
    };
  }
}

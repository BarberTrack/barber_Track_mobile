import 'business_model.dart';

class BusinessesResponseModel {
  final List<BusinessModel> businesses;
  final int total;
  final int page;
  final int totalPages;

  const BusinessesResponseModel({
    required this.businesses,
    required this.total,
    required this.page,
    required this.totalPages,
  });

  factory BusinessesResponseModel.fromJson(Map<String, dynamic> json) {
    final businessesData = json['businesses'] as List<dynamic>? ?? [];

    return BusinessesResponseModel(
      businesses: businessesData
          .map((businessJson) => BusinessModel.fromJson(businessJson))
          .toList(),
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'businesses': businesses.map((business) => business.toJson()).toList(),
      'total': total,
      'page': page,
      'totalPages': totalPages,
    };
  }
}

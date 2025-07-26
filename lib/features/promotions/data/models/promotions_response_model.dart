import 'business_promotions_model.dart';

class PromotionsResponseModel {
  final bool success;
  final String message;
  final BusinessPromotionsModel data;

  PromotionsResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PromotionsResponseModel.fromJson(Map<String, dynamic> json) {
    return PromotionsResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: BusinessPromotionsModel.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
  }
} 
import 'service_model.dart';

class BusinessServicesResponseModel {
  final bool success;
  final String message;
  final BusinessServicesDataModel data;

  BusinessServicesResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory BusinessServicesResponseModel.fromJson(Map<String, dynamic> json) {
    return BusinessServicesResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: BusinessServicesDataModel.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data.toJson()};
  }
}

class BusinessServicesDataModel {
  final List<ServiceModel> services;
  final List<dynamic> packages;

  BusinessServicesDataModel({required this.services, required this.packages});

  factory BusinessServicesDataModel.fromJson(Map<String, dynamic> json) {
    return BusinessServicesDataModel(
      services:
          (json['services'] as List?)
              ?.map((e) => ServiceModel.fromJson(e))
              .toList() ??
          [],
      packages: json['packages'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'services': services.map((e) => e.toJson()).toList(),
      'packages': packages,
    };
  }
}

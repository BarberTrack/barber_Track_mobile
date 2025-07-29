import 'map_business_model.dart';

class MapBusinessesResponseModel {
  final List<MapBusinessModel> businesses;
  final int total;
  final int page;
  final int totalPages;

  const MapBusinessesResponseModel({
    required this.businesses,
    required this.total,
    required this.page,
    required this.totalPages,
  });

  factory MapBusinessesResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final businessesData = data['businesses'] as List<dynamic>;

    return MapBusinessesResponseModel(
      businesses: businessesData
          .map((businessJson) => MapBusinessModel.fromJson(businessJson))
          .toList(),
      total: data['total'] ?? 0,
      page: data['page'] ?? 1,
      totalPages: data['totalPages'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': true,
      'message': 'Barberías listadas exitosamente',
      'data': {
        'businesses': businesses.map((business) => business.toJson()).toList(),
        'total': total,
        'page': page,
        'totalPages': totalPages,
      },
    };
  }
}

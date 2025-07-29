import 'package:equatable/equatable.dart';
import 'map_business.dart';

abstract class MapBusinessesResponse extends Equatable {
  final List<MapBusiness> businesses;
  final int total;
  final int page;
  final int totalPages;

  const MapBusinessesResponse({
    required this.businesses,
    required this.total,
    required this.page,
    required this.totalPages,
  });

  @override
  List<Object?> get props => [businesses, total, page, totalPages];
}

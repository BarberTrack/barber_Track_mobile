import 'package:equatable/equatable.dart';
import 'business.dart';

class BusinessesResponse extends Equatable {
  final List<Business> businesses;
  final int total;
  final int page;
  final int totalPages;

  const BusinessesResponse({
    required this.businesses,
    required this.total,
    required this.page,
    required this.totalPages,
  });

  bool get hasMore => page < totalPages;

  @override
  List<Object> get props => [businesses, total, page, totalPages];
}

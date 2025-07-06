import 'service.dart';

class BusinessServicesResponse {
  final List<Service> services;
  final List<dynamic> packages;

  const BusinessServicesResponse({
    required this.services,
    required this.packages,
  });
}

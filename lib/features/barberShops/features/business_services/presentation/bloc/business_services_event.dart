part of 'business_services_bloc.dart';

abstract class BusinessServicesEvent {
  const BusinessServicesEvent();
}

class LoadBusinessServices extends BusinessServicesEvent {
  final String businessId;

  const LoadBusinessServices(this.businessId);
}

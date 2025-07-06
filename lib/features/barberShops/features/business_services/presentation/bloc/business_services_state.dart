part of 'business_services_bloc.dart';

abstract class BusinessServicesState {
  const BusinessServicesState();
}

class BusinessServicesInitial extends BusinessServicesState {
  const BusinessServicesInitial();
}

class BusinessServicesLoading extends BusinessServicesState {
  const BusinessServicesLoading();
}

class BusinessServicesLoaded extends BusinessServicesState {
  final BusinessServicesResponse businessServices;

  const BusinessServicesLoaded(this.businessServices);
}

class BusinessServicesError extends BusinessServicesState {
  final String message;

  const BusinessServicesError(this.message);
}

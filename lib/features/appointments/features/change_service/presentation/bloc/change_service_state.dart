part of 'change_service_bloc.dart';

abstract class ChangeServiceState extends Equatable {
  const ChangeServiceState();

  @override
  List<Object?> get props => [];
}

class ChangeServiceInitial extends ChangeServiceState {}

class ChangeServiceLoading extends ChangeServiceState {}

class ChangeServiceServicesLoaded extends ChangeServiceState {
  final List<Service> services;
  final String businessId;
  final Appointment originalAppointment;

  const ChangeServiceServicesLoaded({
    required this.services,
    required this.businessId,
    required this.originalAppointment,
  });

  @override
  List<Object> get props => [services, businessId, originalAppointment];
}

class ChangeServiceServiceSelected extends ChangeServiceState {
  final List<Service> services;
  final String businessId;
  final Appointment originalAppointment;
  final Service selectedService;

  const ChangeServiceServiceSelected({
    required this.services,
    required this.businessId,
    required this.originalAppointment,
    required this.selectedService,
  });

  @override
  List<Object> get props => [
    services,
    businessId,
    originalAppointment,
    selectedService,
  ];
}

class ChangeServiceDateTimeOptionSelected extends ChangeServiceState {
  final List<Service> services;
  final String businessId;
  final Appointment originalAppointment;
  final Service selectedService;
  final bool keepDateTime;

  const ChangeServiceDateTimeOptionSelected({
    required this.services,
    required this.businessId,
    required this.originalAppointment,
    required this.selectedService,
    required this.keepDateTime,
  });

  @override
  List<Object> get props => [
    services,
    businessId,
    originalAppointment,
    selectedService,
    keepDateTime,
  ];
}

class ChangeServiceDateSelected extends ChangeServiceState {
  final List<Service> services;
  final String businessId;
  final Appointment originalAppointment;
  final Service selectedService;
  final DateTime selectedDate;

  const ChangeServiceDateSelected({
    required this.services,
    required this.businessId,
    required this.originalAppointment,
    required this.selectedService,
    required this.selectedDate,
  });

  @override
  List<Object> get props => [
    services,
    businessId,
    originalAppointment,
    selectedService,
    selectedDate,
  ];
}

class ChangeServiceAvailabilityLoaded extends ChangeServiceState {
  final List<Service> services;
  final String businessId;
  final Appointment originalAppointment;
  final Service selectedService;
  final DateTime selectedDate;
  final List<Availability> availability;

  const ChangeServiceAvailabilityLoaded({
    required this.services,
    required this.businessId,
    required this.originalAppointment,
    required this.selectedService,
    required this.selectedDate,
    required this.availability,
  });

  @override
  List<Object> get props => [
    services,
    businessId,
    originalAppointment,
    selectedService,
    selectedDate,
    availability,
  ];
}

class ChangeServiceTimeSlotSelected extends ChangeServiceState {
  final List<Service> services;
  final String businessId;
  final Appointment originalAppointment;
  final Service selectedService;
  final DateTime selectedDate;
  final List<Availability> availability;
  final TimeSlot selectedTimeSlot;

  const ChangeServiceTimeSlotSelected({
    required this.services,
    required this.businessId,
    required this.originalAppointment,
    required this.selectedService,
    required this.selectedDate,
    required this.availability,
    required this.selectedTimeSlot,
  });

  @override
  List<Object> get props => [
    services,
    businessId,
    originalAppointment,
    selectedService,
    selectedDate,
    availability,
    selectedTimeSlot,
  ];
}

class ChangeServiceWithNotes extends ChangeServiceState {
  final List<Service> services;
  final String businessId;
  final Appointment originalAppointment;
  final Service selectedService;
  final DateTime? selectedDate;
  final List<Availability>? availability;
  final TimeSlot? selectedTimeSlot;
  final String clientNotes;
  final bool keepDateTime;

  const ChangeServiceWithNotes({
    required this.services,
    required this.businessId,
    required this.originalAppointment,
    required this.selectedService,
    this.selectedDate,
    this.availability,
    this.selectedTimeSlot,
    required this.clientNotes,
    required this.keepDateTime,
  });

  @override
  List<Object?> get props => [
    services,
    businessId,
    originalAppointment,
    selectedService,
    selectedDate,
    availability,
    selectedTimeSlot,
    clientNotes,
    keepDateTime,
  ];
}

class ChangeServiceSubmitting extends ChangeServiceState {}

class ChangeServiceSuccess extends ChangeServiceState {
  final ChangeServiceResponse response;

  const ChangeServiceSuccess(this.response);

  @override
  List<Object> get props => [response];
}

class ChangeServiceError extends ChangeServiceState {
  final String message;

  const ChangeServiceError(this.message);

  @override
  List<Object> get props => [message];
}

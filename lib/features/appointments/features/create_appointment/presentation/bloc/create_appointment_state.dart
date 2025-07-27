part of 'create_appointment_bloc.dart';

abstract class CreateAppointmentState extends Equatable {
  const CreateAppointmentState();

  @override
  List<Object?> get props => [];
}

class CreateAppointmentInitial extends CreateAppointmentState {}

class CreateAppointmentLoading extends CreateAppointmentState {}

class CreateAppointmentServicesLoaded extends CreateAppointmentState {
  final List<Service> services;
  final String businessId;

  const CreateAppointmentServicesLoaded({
    required this.services,
    required this.businessId,
  });

  @override
  List<Object> get props => [services, businessId];
}

class CreateAppointmentServiceSelected extends CreateAppointmentState {
  final List<Service> services;
  final String businessId;
  final Service selectedService;

  const CreateAppointmentServiceSelected({
    required this.services,
    required this.businessId,
    required this.selectedService,
  });

  @override
  List<Object> get props => [services, businessId, selectedService];
}

class CreateAppointmentDateSelected extends CreateAppointmentState {
  final List<Service> services;
  final String businessId;
  final Service selectedService;
  final DateTime selectedDate;

  const CreateAppointmentDateSelected({
    required this.services,
    required this.businessId,
    required this.selectedService,
    required this.selectedDate,
  });

  @override
  List<Object> get props => [
    services,
    businessId,
    selectedService,
    selectedDate,
  ];
}

class CreateAppointmentAvailabilityLoaded extends CreateAppointmentState {
  final List<Service> services;
  final String businessId;
  final Service selectedService;
  final DateTime selectedDate;
  final List<Availability> availability;

  const CreateAppointmentAvailabilityLoaded({
    required this.services,
    required this.businessId,
    required this.selectedService,
    required this.selectedDate,
    required this.availability,
  });

  @override
  List<Object> get props => [
    services,
    businessId,
    selectedService,
    selectedDate,
    availability,
  ];
}

class CreateAppointmentTimeSlotSelected extends CreateAppointmentState {
  final List<Service> services;
  final String businessId;
  final Service selectedService;
  final DateTime selectedDate;
  final List<Availability> availability;
  final TimeSlot selectedTimeSlot;

  const CreateAppointmentTimeSlotSelected({
    required this.services,
    required this.businessId,
    required this.selectedService,
    required this.selectedDate,
    required this.availability,
    required this.selectedTimeSlot,
  });

  @override
  List<Object> get props => [
    services,
    businessId,
    selectedService,
    selectedDate,
    availability,
    selectedTimeSlot,
  ];
}

class CreateAppointmentWithNotes extends CreateAppointmentState {
  final List<Service> services;
  final String businessId;
  final Service selectedService;
  final DateTime selectedDate;
  final List<Availability> availability;
  final TimeSlot selectedTimeSlot;
  final String clientNotes;

  const CreateAppointmentWithNotes({
    required this.services,
    required this.businessId,
    required this.selectedService,
    required this.selectedDate,
    required this.availability,
    required this.selectedTimeSlot,
    required this.clientNotes,
  });

  @override
  List<Object> get props => [
    services,
    businessId,
    selectedService,
    selectedDate,
    availability,
    selectedTimeSlot,
    clientNotes,
  ];
}

class CreateAppointmentNotesError extends CreateAppointmentState {
  final List<Service> services;
  final String businessId;
  final Service selectedService;
  final DateTime selectedDate;
  final List<Availability> availability;
  final TimeSlot selectedTimeSlot;
  final String clientNotes;
  final String errorMessage;

  const CreateAppointmentNotesError({
    required this.services,
    required this.businessId,
    required this.selectedService,
    required this.selectedDate,
    required this.availability,
    required this.selectedTimeSlot,
    required this.clientNotes,
    required this.errorMessage,
  });

  @override
  List<Object> get props => [
    services,
    businessId,
    selectedService,
    selectedDate,
    availability,
    selectedTimeSlot,
    clientNotes,
    errorMessage,
  ];
}

class CreateAppointmentCreating extends CreateAppointmentState {}

class CreateAppointmentSuccess extends CreateAppointmentState {
  final CreateAppointmentResponse response;

  const CreateAppointmentSuccess(this.response);

  @override
  List<Object> get props => [response];
}

class CreateAppointmentError extends CreateAppointmentState {
  final String message;

  const CreateAppointmentError(this.message);

  @override
  List<Object> get props => [message];
}

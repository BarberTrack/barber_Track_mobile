part of 'repeat_appointment_bloc.dart';

abstract class RepeatAppointmentState extends Equatable {
  const RepeatAppointmentState();

  @override
  List<Object?> get props => [];
}

class RepeatAppointmentInitial extends RepeatAppointmentState {}

class RepeatAppointmentLoading extends RepeatAppointmentState {}

class RepeatAppointmentAvailabilityLoaded extends RepeatAppointmentState {
  final AvailabilityResponse availability;
  final String businessId;
  final String serviceId;
  final DateTime selectedDate;

  const RepeatAppointmentAvailabilityLoaded({
    required this.availability,
    required this.businessId,
    required this.serviceId,
    required this.selectedDate,
  });

  @override
  List<Object> get props => [availability, businessId, serviceId, selectedDate];
}

class RepeatAppointmentTimeSlotSelected extends RepeatAppointmentState {
  final AvailabilityResponse availability;
  final String businessId;
  final String serviceId;
  final DateTime selectedDate;
  final TimeSlot selectedTimeSlot;

  const RepeatAppointmentTimeSlotSelected({
    required this.availability,
    required this.businessId,
    required this.serviceId,
    required this.selectedDate,
    required this.selectedTimeSlot,
  });

  @override
  List<Object> get props => [
    availability,
    businessId,
    serviceId,
    selectedDate,
    selectedTimeSlot,
  ];
}

class RepeatAppointmentCreating extends RepeatAppointmentState {}

class RepeatAppointmentSuccess extends RepeatAppointmentState {
  final RepeatAppointmentResponse response;

  const RepeatAppointmentSuccess(this.response);

  @override
  List<Object> get props => [response];
}

class RepeatAppointmentError extends RepeatAppointmentState {
  final String message;

  const RepeatAppointmentError(this.message);

  @override
  List<Object> get props => [message];
}

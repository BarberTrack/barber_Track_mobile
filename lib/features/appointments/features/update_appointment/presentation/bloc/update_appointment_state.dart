part of 'update_appointment_bloc.dart';

abstract class UpdateAppointmentState extends Equatable {
  const UpdateAppointmentState();

  @override
  List<Object?> get props => [];
}

class UpdateAppointmentInitial extends UpdateAppointmentState {}

class UpdateAppointmentLoading extends UpdateAppointmentState {}

class UpdateAppointmentAvailabilityLoaded extends UpdateAppointmentState {
  final List<Availability> availability;
  final String businessId;
  final String barberId;
  final String serviceId;

  const UpdateAppointmentAvailabilityLoaded({
    required this.availability,
    required this.businessId,
    required this.barberId,
    required this.serviceId,
  });

  @override
  List<Object> get props => [availability, businessId, barberId, serviceId];
}

class UpdateAppointmentTimeSlotSelected extends UpdateAppointmentState {
  final List<Availability> availability;
  final String businessId;
  final String barberId;
  final String serviceId;
  final TimeSlot selectedTimeSlot;
  final DateTime selectedDate;

  const UpdateAppointmentTimeSlotSelected({
    required this.availability,
    required this.businessId,
    required this.barberId,
    required this.serviceId,
    required this.selectedTimeSlot,
    required this.selectedDate,
  });

  @override
  List<Object> get props => [
    availability,
    businessId,
    barberId,
    serviceId,
    selectedTimeSlot,
    selectedDate,
  ];
}

class UpdateAppointmentWithNotes extends UpdateAppointmentState {
  final List<Availability> availability;
  final String businessId;
  final String barberId;
  final String serviceId;
  final TimeSlot selectedTimeSlot;
  final DateTime selectedDate;
  final String clientNotes;

  const UpdateAppointmentWithNotes({
    required this.availability,
    required this.businessId,
    required this.barberId,
    required this.serviceId,
    required this.selectedTimeSlot,
    required this.selectedDate,
    required this.clientNotes,
  });

  @override
  List<Object> get props => [
    availability,
    businessId,
    barberId,
    serviceId,
    selectedTimeSlot,
    selectedDate,
    clientNotes,
  ];
}

class UpdateAppointmentUpdating extends UpdateAppointmentState {}

class UpdateAppointmentSuccess extends UpdateAppointmentState {
  final UpdateAppointmentResponse response;

  const UpdateAppointmentSuccess(this.response);

  @override
  List<Object> get props => [response];
}

class UpdateAppointmentError extends UpdateAppointmentState {
  final String message;
  final int? statusCode;

  const UpdateAppointmentError(this.message, {this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

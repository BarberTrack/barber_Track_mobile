part of 'repeat_appointment_bloc.dart';

abstract class RepeatAppointmentEvent extends Equatable {
  const RepeatAppointmentEvent();

  @override
  List<Object> get props => [];
}

class LoadBusinessAvailability extends RepeatAppointmentEvent {
  final String businessId;
  final String barberId;
  final String serviceId;
  final DateTime selectedDate;

  const LoadBusinessAvailability({
    required this.businessId,
    required this.barberId,
    required this.serviceId,
    required this.selectedDate,
  });

  @override
  List<Object> get props => [businessId, barberId, serviceId, selectedDate];
}

class SelectTimeSlot extends RepeatAppointmentEvent {
  final TimeSlot timeSlot;
  final DateTime selectedDate;

  const SelectTimeSlot({required this.timeSlot, required this.selectedDate});

  @override
  List<Object> get props => [timeSlot, selectedDate];
}

class ConfirmRepeatAppointment extends RepeatAppointmentEvent {
  final String appointmentId;
  final TimeSlot selectedTimeSlot;
  final DateTime selectedDate;

  const ConfirmRepeatAppointment({
    required this.appointmentId,
    required this.selectedTimeSlot,
    required this.selectedDate,
  });

  @override
  List<Object> get props => [appointmentId, selectedTimeSlot, selectedDate];
}

class ResetState extends RepeatAppointmentEvent {
  const ResetState();
}

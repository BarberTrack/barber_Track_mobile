part of 'update_appointment_bloc.dart';

abstract class UpdateAppointmentEvent extends Equatable {
  const UpdateAppointmentEvent();

  @override
  List<Object?> get props => [];
}

class LoadAvailability extends UpdateAppointmentEvent {
  final String businessId;
  final String barberId;
  final String serviceId;
  final String date;
  final int days;

  const LoadAvailability({
    required this.businessId,
    required this.barberId,
    required this.serviceId,
    required this.date,
    this.days = 3,
  });

  @override
  List<Object> get props => [businessId, barberId, serviceId, date, days];
}

class SelectTimeSlot extends UpdateAppointmentEvent {
  final TimeSlot timeSlot;
  final DateTime selectedDate;

  const SelectTimeSlot({required this.timeSlot, required this.selectedDate});

  @override
  List<Object> get props => [timeSlot, selectedDate];
}

class UpdateClientNotes extends UpdateAppointmentEvent {
  final String notes;

  const UpdateClientNotes(this.notes);

  @override
  List<Object> get props => [notes];
}

class SubmitUpdateAppointment extends UpdateAppointmentEvent {
  final String appointmentId;
  final String businessId;
  final String barberId;
  final String serviceId;

  const SubmitUpdateAppointment({
    required this.appointmentId,
    required this.businessId,
    required this.barberId,
    required this.serviceId,
  });

  @override
  List<Object> get props => [appointmentId, businessId, barberId, serviceId];
}

class ResetState extends UpdateAppointmentEvent {
  const ResetState();
}

part of 'create_appointment_bloc.dart';

abstract class CreateAppointmentEvent extends Equatable {
  const CreateAppointmentEvent();

  @override
  List<Object> get props => [];
}

class LoadBusinessServices extends CreateAppointmentEvent {
  final String businessId;

  const LoadBusinessServices(this.businessId);

  @override
  List<Object> get props => [businessId];
}

class SelectService extends CreateAppointmentEvent {
  final Service service;

  const SelectService(this.service);

  @override
  List<Object> get props => [service];
}

class SelectDate extends CreateAppointmentEvent {
  final DateTime date;

  const SelectDate(this.date);

  @override
  List<Object> get props => [date];
}

class LoadAvailability extends CreateAppointmentEvent {
  final String businessId;
  final String barberId;
  final String date;
  final int days;

  const LoadAvailability({
    required this.businessId,
    required this.barberId,
    required this.date,
    this.days = 1,
  });

  @override
  List<Object> get props => [businessId, barberId, date, days];
}

class SelectTimeSlot extends CreateAppointmentEvent {
  final TimeSlot timeSlot;

  const SelectTimeSlot(this.timeSlot);

  @override
  List<Object> get props => [timeSlot];
}

class SelectTimeSlotWithDate extends CreateAppointmentEvent {
  final TimeSlot timeSlot;
  final DateTime selectedDate;

  const SelectTimeSlotWithDate({
    required this.timeSlot,
    required this.selectedDate,
  });

  @override
  List<Object> get props => [timeSlot, selectedDate];
}

class UpdateClientNotes extends CreateAppointmentEvent {
  final String notes;

  const UpdateClientNotes(this.notes);

  @override
  List<Object> get props => [notes];
}

class CreateAppointment extends CreateAppointmentEvent {
  const CreateAppointment();
}

class ResetSelection extends CreateAppointmentEvent {
  const ResetSelection();
}

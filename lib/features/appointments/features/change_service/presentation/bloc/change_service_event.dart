part of 'change_service_bloc.dart';

abstract class ChangeServiceEvent extends Equatable {
  const ChangeServiceEvent();

  @override
  List<Object?> get props => [];
}

class LoadBusinessServices extends ChangeServiceEvent {
  final String businessId;
  final Appointment originalAppointment;

  const LoadBusinessServices(this.businessId, this.originalAppointment);

  @override
  List<Object> get props => [businessId, originalAppointment];
}

class SelectService extends ChangeServiceEvent {
  final Service service;

  const SelectService(this.service);

  @override
  List<Object> get props => [service];
}

class SelectKeepDateTime extends ChangeServiceEvent {
  const SelectKeepDateTime();
}

class SelectChangeDateTime extends ChangeServiceEvent {
  const SelectChangeDateTime();
}

class SelectDate extends ChangeServiceEvent {
  final DateTime date;

  const SelectDate(this.date);

  @override
  List<Object> get props => [date];
}

class LoadAvailability extends ChangeServiceEvent {
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

class SelectTimeSlot extends ChangeServiceEvent {
  final TimeSlot timeSlot;

  const SelectTimeSlot(this.timeSlot);

  @override
  List<Object> get props => [timeSlot];
}

class UpdateClientNotes extends ChangeServiceEvent {
  final String notes;

  const UpdateClientNotes(this.notes);

  @override
  List<Object> get props => [notes];
}

class SubmitChangeService extends ChangeServiceEvent {
  const SubmitChangeService();
}

class ResetSelection extends ChangeServiceEvent {
  const ResetSelection();
}

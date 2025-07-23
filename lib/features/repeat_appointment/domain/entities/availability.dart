import 'package:equatable/equatable.dart';

class AvailabilityResponse extends Equatable {
  final String? businessId;
  final List<BarberAvailability> availability;

  const AvailabilityResponse({this.businessId, required this.availability});

  @override
  List<Object?> get props => [businessId, availability];
}

class BarberAvailability extends Equatable {
  final String barberId;
  final String barberName;
  final List<DaySchedule> schedule;

  const BarberAvailability({
    required this.barberId,
    required this.barberName,
    required this.schedule,
  });

  @override
  List<Object> get props => [barberId, barberName, schedule];
}

class DaySchedule extends Equatable {
  final String date;
  final List<TimeSlot> availableSlots;

  const DaySchedule({required this.date, required this.availableSlots});

  @override
  List<Object> get props => [date, availableSlots];
}

class TimeSlot extends Equatable {
  final String time;
  final bool available;
  final String barberId;
  final String barberName;
  final int duration;
  final AppointmentDetails? appointmentDetails;
  final String? blockReason;

  const TimeSlot({
    required this.time,
    required this.available,
    required this.barberId,
    required this.barberName,
    required this.duration,
    this.appointmentDetails,
    this.blockReason,
  });

  @override
  List<Object?> get props => [
    time,
    available,
    barberId,
    barberName,
    duration,
    appointmentDetails,
    blockReason,
  ];
}

class AppointmentDetails extends Equatable {
  final String appointmentId;
  final String clientId;
  final DateTime scheduledDatetime;
  final int durationMinutes;
  final String status;
  final String serviceId;
  final String totalPrice;

  const AppointmentDetails({
    required this.appointmentId,
    required this.clientId,
    required this.scheduledDatetime,
    required this.durationMinutes,
    required this.status,
    required this.serviceId,
    required this.totalPrice,
  });

  @override
  List<Object> get props => [
    appointmentId,
    clientId,
    scheduledDatetime,
    durationMinutes,
    status,
    serviceId,
    totalPrice,
  ];
}

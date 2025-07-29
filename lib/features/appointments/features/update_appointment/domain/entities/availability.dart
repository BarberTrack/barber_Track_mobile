import 'package:equatable/equatable.dart';

class Availability extends Equatable {
  final String date;
  final List<TimeSlot> slots;

  const Availability({required this.date, required this.slots});

  @override
  List<Object> get props => [date, slots];
}

class TimeSlot extends Equatable {
  final String time;
  final bool available;
  final String barberId;
  final String barberName;
  final int duration;
  final String? blockReason;

  const TimeSlot({
    required this.time,
    required this.available,
    required this.barberId,
    required this.barberName,
    required this.duration,
    this.blockReason,
  });

  @override
  List<Object?> get props => [
    time,
    available,
    barberId,
    barberName,
    duration,
    blockReason,
  ];
}

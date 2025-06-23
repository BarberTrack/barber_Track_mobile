import 'package:equatable/equatable.dart';

class TimeSlot extends Equatable {
  final String time;
  final bool available;
  final String barberId;
  final String barberName;
  final int duration;

  const TimeSlot({
    required this.time,
    required this.available,
    required this.barberId,
    required this.barberName,
    required this.duration,
  });

  @override
  List<Object?> get props => [time, available, barberId, barberName, duration];
}

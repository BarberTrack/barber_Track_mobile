import 'package:equatable/equatable.dart';
import 'time_slot.dart';

class Availability extends Equatable {
  final String date;
  final List<TimeSlot> slots;

  const Availability({required this.date, required this.slots});

  @override
  List<Object?> get props => [date, slots];
}

import 'package:equatable/equatable.dart';

class AvailabilityModel extends Equatable {
  final String date;
  final List<TimeSlotModel> slots;

  const AvailabilityModel({required this.date, required this.slots});

  factory AvailabilityModel.fromJson(Map<String, dynamic> json) {
    return AvailabilityModel(
      date: json['date'] as String,
      slots: (json['slots'] as List<dynamic>)
          .map((slot) => TimeSlotModel.fromJson(slot as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'date': date, 'slots': slots.map((slot) => slot.toJson()).toList()};
  }

  @override
  List<Object> get props => [date, slots];
}

class TimeSlotModel extends Equatable {
  final String time;
  final bool available;
  final String barberId;
  final String barberName;
  final int duration;
  final String? blockReason;

  const TimeSlotModel({
    required this.time,
    required this.available,
    required this.barberId,
    required this.barberName,
    required this.duration,
    this.blockReason,
  });

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) {
    return TimeSlotModel(
      time: json['time'] as String,
      available: json['available'] as bool,
      barberId: json['barberId'] as String,
      barberName: json['barberName'] as String,
      duration: json['duration'] as int,
      blockReason: json['blockReason'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'available': available,
      'barberId': barberId,
      'barberName': barberName,
      'duration': duration,
      if (blockReason != null) 'blockReason': blockReason,
    };
  }

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

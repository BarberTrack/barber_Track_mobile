class TimeSlotModel {
  final String time;
  final bool available;
  final String barberId;
  final String barberName;
  final int duration;

  const TimeSlotModel({
    required this.time,
    required this.available,
    required this.barberId,
    required this.barberName,
    required this.duration,
  });

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) {
    return TimeSlotModel(
      time: json['time'] ?? '',
      available: json['available'] ?? false,
      barberId: json['barberId'] ?? '',
      barberName: json['barberName'] ?? '',
      duration: json['duration'] ?? 0,
    );
  }
}

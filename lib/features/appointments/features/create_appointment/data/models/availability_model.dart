import 'time_slot_model.dart';

class AvailabilityModel {
  final String date;
  final List<TimeSlotModel> slots;

  const AvailabilityModel({required this.date, required this.slots});

  factory AvailabilityModel.fromJson(Map<String, dynamic> json) {
    return AvailabilityModel(
      date: json['date'] ?? '',
      slots:
          (json['slots'] as List<dynamic>?)
              ?.map(
                (item) => TimeSlotModel.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }
}

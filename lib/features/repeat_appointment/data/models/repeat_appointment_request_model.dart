import 'package:equatable/equatable.dart';

class RepeatAppointmentRequestModel extends Equatable {
  final String scheduledDatetime;

  const RepeatAppointmentRequestModel({required this.scheduledDatetime});

  Map<String, dynamic> toJson() {
    return {'scheduledDatetime': scheduledDatetime};
  }

  factory RepeatAppointmentRequestModel.fromJson(Map<String, dynamic> json) {
    return RepeatAppointmentRequestModel(
      scheduledDatetime: json['scheduledDatetime'] as String,
    );
  }

  @override
  List<Object> get props => [scheduledDatetime];
}

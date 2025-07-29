import 'package:equatable/equatable.dart';

class ChangeServiceRequestModel extends Equatable {
  final String scheduledDatetime;
  final String barberId;
  final String serviceId;
  final String? clientNotes;

  const ChangeServiceRequestModel({
    required this.scheduledDatetime,
    required this.barberId,
    required this.serviceId,
    this.clientNotes,
  });

  Map<String, dynamic> toJson() {
    return {
      'scheduledDatetime': scheduledDatetime,
      'barberId': barberId,
      'serviceId': serviceId,
      if (clientNotes != null) 'clientNotes': clientNotes,
    };
  }

  factory ChangeServiceRequestModel.fromJson(Map<String, dynamic> json) {
    return ChangeServiceRequestModel(
      scheduledDatetime: json['scheduledDatetime'] as String,
      barberId: json['barberId'] as String,
      serviceId: json['serviceId'] as String,
      clientNotes: json['clientNotes'] as String?,
    );
  }

  @override
  List<Object?> get props => [
    scheduledDatetime,
    barberId,
    serviceId,
    clientNotes,
  ];
}

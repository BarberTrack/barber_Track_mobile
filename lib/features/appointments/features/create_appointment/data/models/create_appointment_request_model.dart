import 'package:equatable/equatable.dart';

class CreateAppointmentRequestModel extends Equatable {
  final String businessId;
  final String barberId;
  final String serviceId;
  final String scheduledDatetime;
  final String? clientNotes;

  const CreateAppointmentRequestModel({
    required this.businessId,
    required this.barberId,
    required this.serviceId,
    required this.scheduledDatetime,
    this.clientNotes,
  });

  Map<String, dynamic> toJson() {
    return {
      'businessId': businessId,
      'barberId': barberId,
      'serviceId': serviceId,
      'scheduledDatetime': scheduledDatetime,
      if (clientNotes != null) 'clientNotes': clientNotes,
    };
  }

  factory CreateAppointmentRequestModel.fromJson(Map<String, dynamic> json) {
    return CreateAppointmentRequestModel(
      businessId: json['businessId'] as String,
      barberId: json['barberId'] as String,
      serviceId: json['serviceId'] as String,
      scheduledDatetime: json['scheduledDatetime'] as String,
      clientNotes: json['clientNotes'] as String?,
    );
  }

  @override
  List<Object?> get props => [
    businessId,
    barberId,
    serviceId,
    scheduledDatetime,
    clientNotes,
  ];
}

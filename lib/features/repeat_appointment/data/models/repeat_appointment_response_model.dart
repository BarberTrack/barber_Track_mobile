import 'package:equatable/equatable.dart';

class RepeatAppointmentResponseModel extends Equatable {
  final bool success;
  final String message;
  final RepeatAppointmentDataModel data;

  const RepeatAppointmentResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory RepeatAppointmentResponseModel.fromJson(Map<String, dynamic> json) {
    return RepeatAppointmentResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: RepeatAppointmentDataModel.fromJson(
        json['data'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data.toJson()};
  }

  @override
  List<Object> get props => [success, message, data];
}

class RepeatAppointmentDataModel extends Equatable {
  final RepeatedAppointmentModel appointment;
  final bool created;
  final String confirmationCode;

  const RepeatAppointmentDataModel({
    required this.appointment,
    required this.created,
    required this.confirmationCode,
  });

  factory RepeatAppointmentDataModel.fromJson(Map<String, dynamic> json) {
    return RepeatAppointmentDataModel(
      appointment: RepeatedAppointmentModel.fromJson(
        json['appointment'] as Map<String, dynamic>,
      ),
      created: json['created'] as bool,
      confirmationCode: json['confirmationCode'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appointment': appointment.toJson(),
      'created': created,
      'confirmationCode': confirmationCode,
    };
  }

  @override
  List<Object> get props => [appointment, created, confirmationCode];
}

class RepeatedAppointmentModel extends Equatable {
  final String id;
  final String clientId;
  final String businessId;
  final String barberId;
  final String serviceId;
  final String? packageId;
  final String scheduledDatetime;
  final int durationMinutes;
  final String totalPrice;
  final String status;
  final String? clientNotes;
  final String? barberNotes;
  final List<StatusHistoryModel> statusHistory;
  final String createdAt;
  final String updatedAt;
  final String? cancelledAt;
  final String? cancelledById;
  final String? reminder24hSentAt;
  final String? reminder2hSentAt;
  final bool remindersEnabled;
  final AppointmentBusinessModel business;
  final AppointmentBarberModel barber;
  final AppointmentServiceModel service;

  const RepeatedAppointmentModel({
    required this.id,
    required this.clientId,
    required this.businessId,
    required this.barberId,
    required this.serviceId,
    this.packageId,
    required this.scheduledDatetime,
    required this.durationMinutes,
    required this.totalPrice,
    required this.status,
    this.clientNotes,
    this.barberNotes,
    required this.statusHistory,
    required this.createdAt,
    required this.updatedAt,
    this.cancelledAt,
    this.cancelledById,
    this.reminder24hSentAt,
    this.reminder2hSentAt,
    required this.remindersEnabled,
    required this.business,
    required this.barber,
    required this.service,
  });

  factory RepeatedAppointmentModel.fromJson(Map<String, dynamic> json) {
    return RepeatedAppointmentModel(
      id: json['id'] as String,
      clientId: json['clientId'] as String,
      businessId: json['businessId'] as String,
      barberId: json['barberId'] as String,
      serviceId: json['serviceId'] as String,
      packageId: json['packageId'] as String?,
      scheduledDatetime: json['scheduledDatetime'] as String,
      durationMinutes: json['durationMinutes'] as int,
      totalPrice: json['totalPrice'] as String,
      status: json['status'] as String,
      clientNotes: json['clientNotes'] as String?,
      barberNotes: json['barberNotes'] as String?,
      statusHistory: (json['statusHistory'] as List<dynamic>)
          .map(
            (item) => StatusHistoryModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      cancelledAt: json['cancelledAt'] as String?,
      cancelledById: json['cancelledById'] as String?,
      reminder24hSentAt: json['reminder24hSentAt'] as String?,
      reminder2hSentAt: json['reminder2hSentAt'] as String?,
      remindersEnabled: json['remindersEnabled'] as bool,
      business: AppointmentBusinessModel.fromJson(
        json['business'] as Map<String, dynamic>,
      ),
      barber: AppointmentBarberModel.fromJson(
        json['barber'] as Map<String, dynamic>,
      ),
      service: AppointmentServiceModel.fromJson(
        json['service'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientId': clientId,
      'businessId': businessId,
      'barberId': barberId,
      'serviceId': serviceId,
      if (packageId != null) 'packageId': packageId,
      'scheduledDatetime': scheduledDatetime,
      'durationMinutes': durationMinutes,
      'totalPrice': totalPrice,
      'status': status,
      if (clientNotes != null) 'clientNotes': clientNotes,
      if (barberNotes != null) 'barberNotes': barberNotes,
      'statusHistory': statusHistory.map((item) => item.toJson()).toList(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      if (cancelledAt != null) 'cancelledAt': cancelledAt,
      if (cancelledById != null) 'cancelledById': cancelledById,
      if (reminder24hSentAt != null) 'reminder24hSentAt': reminder24hSentAt,
      if (reminder2hSentAt != null) 'reminder2hSentAt': reminder2hSentAt,
      'remindersEnabled': remindersEnabled,
      'business': business.toJson(),
      'barber': barber.toJson(),
      'service': service.toJson(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    clientId,
    businessId,
    barberId,
    serviceId,
    packageId,
    scheduledDatetime,
    durationMinutes,
    totalPrice,
    status,
    clientNotes,
    barberNotes,
    statusHistory,
    createdAt,
    updatedAt,
    cancelledAt,
    cancelledById,
    reminder24hSentAt,
    reminder2hSentAt,
    remindersEnabled,
    business,
    barber,
    service,
  ];
}

class StatusHistoryModel extends Equatable {
  final String reason;
  final String toStatus;
  final String changedBy;
  final String timestamp;
  final String? fromStatus;

  const StatusHistoryModel({
    required this.reason,
    required this.toStatus,
    required this.changedBy,
    required this.timestamp,
    this.fromStatus,
  });

  factory StatusHistoryModel.fromJson(Map<String, dynamic> json) {
    return StatusHistoryModel(
      reason: json['reason'] as String,
      toStatus: json['toStatus'] as String,
      changedBy: json['changedBy'] as String,
      timestamp: json['timestamp'] as String,
      fromStatus: json['fromStatus'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reason': reason,
      'toStatus': toStatus,
      'changedBy': changedBy,
      'timestamp': timestamp,
      if (fromStatus != null) 'fromStatus': fromStatus,
    };
  }

  @override
  List<Object?> get props => [
    reason,
    toStatus,
    changedBy,
    timestamp,
    fromStatus,
  ];
}

class AppointmentBusinessModel extends Equatable {
  final String name;
  final String address;
  final String phone;

  const AppointmentBusinessModel({
    required this.name,
    required this.address,
    required this.phone,
  });

  factory AppointmentBusinessModel.fromJson(Map<String, dynamic> json) {
    return AppointmentBusinessModel(
      name: json['name'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'address': address, 'phone': phone};
  }

  @override
  List<Object> get props => [name, address, phone];
}

class AppointmentBarberModel extends Equatable {
  final String name;
  final String firstName;
  final String lastName;
  final List<String> specialties;

  const AppointmentBarberModel({
    required this.name,
    required this.firstName,
    required this.lastName,
    required this.specialties,
  });

  factory AppointmentBarberModel.fromJson(Map<String, dynamic> json) {
    return AppointmentBarberModel(
      name: json['name'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      specialties: (json['specialties'] as List<dynamic>).cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'firstName': firstName,
      'lastName': lastName,
      'specialties': specialties,
    };
  }

  @override
  List<Object> get props => [name, firstName, lastName, specialties];
}

class AppointmentServiceModel extends Equatable {
  final String name;
  final int duration;
  final String price;
  final String description;

  const AppointmentServiceModel({
    required this.name,
    required this.duration,
    required this.price,
    required this.description,
  });

  factory AppointmentServiceModel.fromJson(Map<String, dynamic> json) {
    return AppointmentServiceModel(
      name: json['name'] as String,
      duration: json['duration'] as int,
      price: json['price'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'duration': duration,
      'price': price,
      'description': description,
    };
  }

  @override
  List<Object> get props => [name, duration, price, description];
}

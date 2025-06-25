import 'package:equatable/equatable.dart';

class AppointmentsResponseModel extends Equatable {
  final bool success;
  final String message;
  final AppointmentsDataModel data;

  const AppointmentsResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AppointmentsResponseModel.fromJson(Map<String, dynamic> json) {
    return AppointmentsResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: AppointmentsDataModel.fromJson(
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

class AppointmentsDataModel extends Equatable {
  final List<AppointmentModel> appointments;
  final int total;
  final int page;
  final int totalPages;

  const AppointmentsDataModel({
    required this.appointments,
    required this.total,
    required this.page,
    required this.totalPages,
  });

  factory AppointmentsDataModel.fromJson(Map<String, dynamic> json) {
    return AppointmentsDataModel(
      appointments: (json['appointments'] as List<dynamic>)
          .map((e) => AppointmentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
      page: json['page'] as int,
      totalPages: json['totalPages'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appointments': appointments.map((e) => e.toJson()).toList(),
      'total': total,
      'page': page,
      'totalPages': totalPages,
    };
  }

  @override
  List<Object> get props => [appointments, total, page, totalPages];
}

class AppointmentModel extends Equatable {
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

  const AppointmentModel({
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

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
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
          .map((e) => StatusHistoryModel.fromJson(e as Map<String, dynamic>))
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
      'packageId': packageId,
      'scheduledDatetime': scheduledDatetime,
      'durationMinutes': durationMinutes,
      'totalPrice': totalPrice,
      'status': status,
      'clientNotes': clientNotes,
      'barberNotes': barberNotes,
      'statusHistory': statusHistory.map((e) => e.toJson()).toList(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'cancelledAt': cancelledAt,
      'cancelledById': cancelledById,
      'reminder24hSentAt': reminder24hSentAt,
      'reminder2hSentAt': reminder2hSentAt,
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
      'fromStatus': fromStatus,
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

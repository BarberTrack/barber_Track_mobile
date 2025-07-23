import 'package:equatable/equatable.dart';

class UpdateAppointmentRequest extends Equatable {
  final String appointmentId;
  final String scheduledDatetime;
  final String barberId;
  final String serviceId;
  final String? clientNotes;

  const UpdateAppointmentRequest({
    required this.appointmentId,
    required this.scheduledDatetime,
    required this.barberId,
    required this.serviceId,
    this.clientNotes,
  });

  @override
  List<Object?> get props => [
    appointmentId,
    scheduledDatetime,
    barberId,
    serviceId,
    clientNotes,
  ];
}

class UpdateAppointmentResponse extends Equatable {
  final UpdatedAppointment appointment;
  final bool updated;
  final Map<String, dynamic> changes;

  const UpdateAppointmentResponse({
    required this.appointment,
    required this.updated,
    required this.changes,
  });

  @override
  List<Object> get props => [appointment, updated, changes];
}

class UpdatedAppointment extends Equatable {
  final String id;
  final String clientId;
  final String businessId;
  final String barberId;
  final String serviceId;
  final String? packageId;
  final DateTime scheduledDatetime;
  final int durationMinutes;
  final String totalPrice;
  final String status;
  final String? clientNotes;
  final String? barberNotes;
  final List<StatusHistory> statusHistory;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? cancelledAt;
  final String? cancelledById;
  final DateTime? reminder24hSentAt;
  final DateTime? reminder2hSentAt;
  final bool remindersEnabled;
  final AppointmentBusiness business;
  final AppointmentBarber barber;
  final AppointmentService service;

  const UpdatedAppointment({
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

class StatusHistory extends Equatable {
  final String reason;
  final String toStatus;
  final String changedBy;
  final DateTime timestamp;
  final String? fromStatus;
  final Map<String, dynamic>? metadata;

  const StatusHistory({
    required this.reason,
    required this.toStatus,
    required this.changedBy,
    required this.timestamp,
    this.fromStatus,
    this.metadata,
  });

  @override
  List<Object?> get props => [
    reason,
    toStatus,
    changedBy,
    timestamp,
    fromStatus,
    metadata,
  ];
}

class AppointmentBusiness extends Equatable {
  final String name;
  final String address;
  final String phone;

  const AppointmentBusiness({
    required this.name,
    required this.address,
    required this.phone,
  });

  @override
  List<Object> get props => [name, address, phone];
}

class AppointmentBarber extends Equatable {
  final String name;
  final String firstName;
  final String lastName;
  final List<String> specialties;

  const AppointmentBarber({
    required this.name,
    required this.firstName,
    required this.lastName,
    required this.specialties,
  });

  @override
  List<Object> get props => [name, firstName, lastName, specialties];
}

class AppointmentService extends Equatable {
  final String name;
  final int duration;
  final String price;
  final String description;

  const AppointmentService({
    required this.name,
    required this.duration,
    required this.price,
    required this.description,
  });

  @override
  List<Object> get props => [name, duration, price, description];
}

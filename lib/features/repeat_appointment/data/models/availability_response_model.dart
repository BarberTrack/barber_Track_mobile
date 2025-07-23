import 'package:equatable/equatable.dart';

class AvailabilityResponseModel extends Equatable {
  final bool success;
  final String message;
  final AvailabilityDataModel data;

  const AvailabilityResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AvailabilityResponseModel.fromJson(Map<String, dynamic> json) {
    return AvailabilityResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: AvailabilityDataModel.fromJson(
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

class AvailabilityDataModel extends Equatable {
  final List<DayAvailabilityModel> availability;

  const AvailabilityDataModel({required this.availability});

  factory AvailabilityDataModel.fromJson(Map<String, dynamic> json) {
    return AvailabilityDataModel(
      availability: (json['availability'] as List<dynamic>)
          .map(
            (item) =>
                DayAvailabilityModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'availability': availability.map((item) => item.toJson()).toList()};
  }

  @override
  List<Object> get props => [availability];
}

class DayAvailabilityModel extends Equatable {
  final String date;
  final List<TimeSlotModel> slots;

  const DayAvailabilityModel({required this.date, required this.slots});

  factory DayAvailabilityModel.fromJson(Map<String, dynamic> json) {
    return DayAvailabilityModel(
      date: json['date'] as String,
      slots: (json['slots'] as List<dynamic>)
          .map((item) => TimeSlotModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'date': date, 'slots': slots.map((item) => item.toJson()).toList()};
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

// Mantener las clases antiguas para compatibilidad (ya no se usan en el nuevo response)
class BarberAvailabilityModel extends Equatable {
  final String barberId;
  final String barberName;
  final List<DayScheduleModel> schedule;

  const BarberAvailabilityModel({
    required this.barberId,
    required this.barberName,
    required this.schedule,
  });

  factory BarberAvailabilityModel.fromJson(Map<String, dynamic> json) {
    return BarberAvailabilityModel(
      barberId: json['barberId'] as String,
      barberName: json['barberName'] as String,
      schedule: (json['schedule'] as List<dynamic>)
          .map(
            (item) => DayScheduleModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'barberId': barberId,
      'barberName': barberName,
      'schedule': schedule.map((item) => item.toJson()).toList(),
    };
  }

  @override
  List<Object> get props => [barberId, barberName, schedule];
}

class DayScheduleModel extends Equatable {
  final String date;
  final List<TimeSlotModel> availableSlots;

  const DayScheduleModel({required this.date, required this.availableSlots});

  factory DayScheduleModel.fromJson(Map<String, dynamic> json) {
    return DayScheduleModel(
      date: json['date'] as String,
      availableSlots: (json['availableSlots'] as List<dynamic>)
          .map((item) => TimeSlotModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'availableSlots': availableSlots.map((item) => item.toJson()).toList(),
    };
  }

  @override
  List<Object> get props => [date, availableSlots];
}

class AppointmentDetailsModel extends Equatable {
  final String appointmentId;
  final String clientId;
  final String scheduledDatetime;
  final int durationMinutes;
  final String status;
  final String serviceId;
  final String totalPrice;

  const AppointmentDetailsModel({
    required this.appointmentId,
    required this.clientId,
    required this.scheduledDatetime,
    required this.durationMinutes,
    required this.status,
    required this.serviceId,
    required this.totalPrice,
  });

  factory AppointmentDetailsModel.fromJson(Map<String, dynamic> json) {
    return AppointmentDetailsModel(
      appointmentId: json['appointmentId'] as String,
      clientId: json['clientId'] as String,
      scheduledDatetime: json['scheduledDatetime'] as String,
      durationMinutes: json['durationMinutes'] as int,
      status: json['status'] as String,
      serviceId: json['serviceId'] as String,
      totalPrice: json['totalPrice'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appointmentId': appointmentId,
      'clientId': clientId,
      'scheduledDatetime': scheduledDatetime,
      'durationMinutes': durationMinutes,
      'status': status,
      'serviceId': serviceId,
      'totalPrice': totalPrice,
    };
  }

  @override
  List<Object> get props => [
    appointmentId,
    clientId,
    scheduledDatetime,
    durationMinutes,
    status,
    serviceId,
    totalPrice,
  ];
}

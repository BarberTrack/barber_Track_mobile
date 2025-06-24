import '../../domain/entities/appointment.dart';
import '../models/create_appointment_request_model.dart';
import '../models/create_appointment_response_model.dart';

class AppointmentMapper {
  static CreateAppointmentRequestModel toRequestModel(
    CreateAppointmentRequest entity,
  ) {
    return CreateAppointmentRequestModel(
      businessId: entity.businessId,
      barberId: entity.barberId,
      serviceId: entity.serviceId,
      scheduledDatetime: entity.scheduledDatetime,
      clientNotes: entity.clientNotes,
    );
  }

  static CreateAppointmentResponse toResponseEntity(
    CreateAppointmentResponseModel model,
  ) {
    return CreateAppointmentResponse(
      appointment: _toAppointmentEntity(model.data.appointment),
      created: model.data.created,
      confirmationCode: model.data.confirmationCode,
    );
  }

  static Appointment _toAppointmentEntity(AppointmentModel model) {
    return Appointment(
      id: model.id,
      clientId: model.clientId,
      businessId: model.businessId,
      barberId: model.barberId,
      serviceId: model.serviceId,
      packageId: model.packageId,
      scheduledDatetime: DateTime.parse(model.scheduledDatetime),
      durationMinutes: model.durationMinutes,
      totalPrice: model.totalPrice,
      status: model.status,
      clientNotes: model.clientNotes,
      barberNotes: model.barberNotes,
      statusHistory: model.statusHistory.map(_toStatusHistoryEntity).toList(),
      createdAt: DateTime.parse(model.createdAt),
      updatedAt: DateTime.parse(model.updatedAt),
      cancelledAt: model.cancelledAt != null
          ? DateTime.parse(model.cancelledAt!)
          : null,
      cancelledById: model.cancelledById,
      reminder24hSentAt: model.reminder24hSentAt != null
          ? DateTime.parse(model.reminder24hSentAt!)
          : null,
      reminder2hSentAt: model.reminder2hSentAt != null
          ? DateTime.parse(model.reminder2hSentAt!)
          : null,
      remindersEnabled: model.remindersEnabled,
      business: _toAppointmentBusinessEntity(model.business),
      barber: _toAppointmentBarberEntity(model.barber),
      service: _toAppointmentServiceEntity(model.service),
    );
  }

  static StatusHistory _toStatusHistoryEntity(StatusHistoryModel model) {
    return StatusHistory(
      reason: model.reason,
      toStatus: model.toStatus,
      changedBy: model.changedBy,
      timestamp: DateTime.parse(model.timestamp),
      fromStatus: model.fromStatus,
    );
  }

  static AppointmentBusiness _toAppointmentBusinessEntity(
    AppointmentBusinessModel model,
  ) {
    return AppointmentBusiness(
      name: model.name,
      address: model.address,
      phone: model.phone,
    );
  }

  static AppointmentBarber _toAppointmentBarberEntity(
    AppointmentBarberModel model,
  ) {
    return AppointmentBarber(
      name: model.name,
      firstName: model.firstName,
      lastName: model.lastName,
      specialties: model.specialties,
    );
  }

  static AppointmentService _toAppointmentServiceEntity(
    AppointmentServiceModel model,
  ) {
    return AppointmentService(
      name: model.name,
      duration: model.duration,
      price: model.price,
      description: model.description,
    );
  }
}

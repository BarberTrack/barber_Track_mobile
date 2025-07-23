import '../../domain/entities/update_appointment.dart';
import '../models/update_appointment_request_model.dart';
import '../models/update_appointment_response_model.dart';

class UpdateAppointmentMapper {
  static UpdateAppointmentRequestModel toRequestModel(
    UpdateAppointmentRequest entity,
  ) {
    return UpdateAppointmentRequestModel(
      scheduledDatetime: entity.scheduledDatetime,
      barberId: entity.barberId,
      serviceId: entity.serviceId,
      clientNotes: entity.clientNotes,
    );
  }

  static UpdateAppointmentResponse toResponseEntity(
    UpdateAppointmentResponseModel model,
  ) {
    return UpdateAppointmentResponse(
      appointment: _toUpdatedAppointmentEntity(model.data.appointment),
      updated: model.data.updated,
      changes: model.data.changes,
    );
  }

  static UpdatedAppointment _toUpdatedAppointmentEntity(
    UpdatedAppointmentModel model,
  ) {
    return UpdatedAppointment(
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
      statusHistory: model.statusHistory
          .map((history) => _toStatusHistoryEntity(history))
          .toList(),
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
      metadata: model.metadata,
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

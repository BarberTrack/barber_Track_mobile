import '../../domain/entities/change_service_request.dart';
import '../../domain/entities/change_service_response.dart';
import '../models/change_service_request_model.dart';
import '../models/change_service_response_model.dart';
import '../../../appoinments_home/data/mappers/appointments_mapper.dart';

class ChangeServiceMapper {
  // Convertir de entidad a modelo
  static ChangeServiceRequestModel toRequestModel(ChangeServiceRequest entity) {
    return ChangeServiceRequestModel(
      scheduledDatetime: entity.scheduledDatetime,
      barberId: entity.barberId,
      serviceId: entity.serviceId,
      clientNotes: entity.clientNotes,
    );
  }

  // Convertir de modelo a entidad
  static ChangeServiceRequest toRequestEntity(ChangeServiceRequestModel model) {
    return ChangeServiceRequest(
      scheduledDatetime: model.scheduledDatetime,
      barberId: model.barberId,
      serviceId: model.serviceId,
      clientNotes: model.clientNotes,
    );
  }

  // Convertir respuesta de modelo a entidad
  static ChangeServiceResponse toResponseEntity(
    ChangeServiceResponseModel model,
  ) {
    return ChangeServiceResponse(
      success: model.success,
      message: model.message,
      data: ChangeServiceData(
        appointment: AppointmentsMapper.toAppointmentEntity(
          model.data.appointment,
        ),
        updated: model.data.updated,
        changes: model.data.changes,
      ),
    );
  }

  // Nota: La conversión de entidad a modelo no es necesaria para este caso de uso
}

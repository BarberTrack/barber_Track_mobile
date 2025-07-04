import '../../domain/entities/cancel_appointment_response.dart';
import '../models/cancel_appointment_response_model.dart';
import '../../../appoinments_home/data/mappers/appointments_mapper.dart';

class CancelAppointmentMapper {
  static CancelAppointmentResponse modelToEntity(
    CancelAppointmentResponseModel model,
  ) {
    return CancelAppointmentResponse(
      success: model.success,
      message: model.message,
      data: AppointmentsMapper.toAppointmentEntity(model.data),
    );
  }
}

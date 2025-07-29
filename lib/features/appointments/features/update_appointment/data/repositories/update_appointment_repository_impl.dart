import '../../domain/entities/availability.dart';
import '../../domain/entities/update_appointment.dart';
import '../../domain/repositories/update_appointment_repository.dart';
import '../datasources/update_appointment_remote_data_source.dart';
import '../mappers/availability_mapper.dart';
import '../mappers/update_appointment_mapper.dart';

class UpdateAppointmentRepositoryImpl implements UpdateAppointmentRepository {
  final UpdateAppointmentRemoteDataSource remoteDataSource;

  UpdateAppointmentRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Availability>> getAvailability({
    required String businessId,
    required String barberId,
    required String serviceId,
    required String date,
    int days = 3,
  }) async {
    try {
      final models = await remoteDataSource.getAvailability(
        businessId: businessId,
        barberId: barberId,
        serviceId: serviceId,
        date: date,
        days: days,
      );
      return AvailabilityMapper.modelsToEntities(models);
    } catch (e) {
      throw Exception('Error en repositorio de disponibilidad: $e');
    }
  }

  @override
  Future<UpdateAppointmentResponse> updateAppointment(
    UpdateAppointmentRequest request,
  ) async {
    try {
      final requestModel = UpdateAppointmentMapper.toRequestModel(request);
      final responseModel = await remoteDataSource.updateAppointment(
        request.appointmentId,
        requestModel,
      );
      return UpdateAppointmentMapper.toResponseEntity(responseModel);
    } catch (e) {
      throw Exception('Error en repositorio al actualizar cita: $e');
    }
  }
}

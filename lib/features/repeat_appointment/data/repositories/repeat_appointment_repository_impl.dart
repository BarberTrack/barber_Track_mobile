import '../../domain/entities/availability.dart';
import '../../domain/entities/repeat_appointment.dart';
import '../../domain/repositories/repeat_appointment_repository.dart';
import '../datasources/repeat_appointment_remote_data_source.dart';
import '../mappers/availability_mapper.dart';
import '../mappers/repeat_appointment_mapper.dart';

class RepeatAppointmentRepositoryImpl implements RepeatAppointmentRepository {
  final RepeatAppointmentRemoteDataSource remoteDataSource;

  RepeatAppointmentRepositoryImpl(this.remoteDataSource);

  @override
  Future<AvailabilityResponse> getBusinessAvailability({
    required String businessId,
    required String barberId,
    required String serviceId,
    required String date,
    int days = 3,
  }) async {
    try {
      final dataModel = await remoteDataSource.getBusinessAvailability(
        businessId: businessId,
        barberId: barberId,
        serviceId: serviceId,
        date: date,
        days: days,
      );
      return AvailabilityMapper.toEntity(dataModel);
    } catch (e) {
      throw Exception('Error en repositorio de disponibilidad: $e');
    }
  }

  @override
  Future<RepeatAppointmentResponse> repeatAppointment(
    RepeatAppointmentRequest request,
  ) async {
    try {
      final requestModel = RepeatAppointmentMapper.toRequestModel(request);
      final responseModel = await remoteDataSource.repeatAppointment(
        request.appointmentId,
        requestModel,
      );
      return RepeatAppointmentMapper.toResponseEntity(responseModel);
    } catch (e) {
      throw Exception('Error en repositorio al repetir cita: $e');
    }
  }
}

import '../../domain/entities/service.dart';
import '../../domain/entities/availability.dart';
import '../../domain/entities/appointment.dart';
import '../../domain/repositories/appointment_repository.dart';
import '../datasources/appointment_remote_data_source.dart';
import '../mappers/service_mapper.dart';
import '../mappers/availability_mapper.dart';
import '../mappers/appointment_mapper.dart';

class AppointmentRepositoryImpl implements AppointmentRepository {
  final AppointmentRemoteDataSource remoteDataSource;

  AppointmentRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Service>> getBusinessServices(String businessId) async {
    try {
      final models = await remoteDataSource.getBusinessServices(businessId);
      return ServiceMapper.modelsToEntities(models);
    } catch (e) {
      throw Exception('Error en repositorio de servicios: $e');
    }
  }

  @override
  Future<List<Availability>> getAvailability({
    required String businessId,
    required String barberId,
    required String date,
    int days = 1,
  }) async {
    try {
      final models = await remoteDataSource.getAvailability(
        businessId: businessId,
        barberId: barberId,
        date: date,
        days: days,
      );
      return AvailabilityMapper.modelsToEntities(models);
    } catch (e) {
      throw Exception('Error en repositorio de disponibilidad: $e');
    }
  }

  @override
  Future<CreateAppointmentResponse> createAppointment(
    CreateAppointmentRequest request,
  ) async {
    try {
      final requestModel = AppointmentMapper.toRequestModel(request);
      final responseModel = await remoteDataSource.createAppointment(
        requestModel,
      );
      return AppointmentMapper.toResponseEntity(responseModel);
    } catch (e) {
      throw Exception('Error en repositorio al crear cita: $e');
    }
  }
}

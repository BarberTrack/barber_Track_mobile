import '../../../create_appointment/domain/entities/service.dart';
import '../../../create_appointment/domain/entities/availability.dart';
import '../../domain/entities/change_service_request.dart';
import '../../domain/entities/change_service_response.dart';
import '../../domain/repositories/change_service_repository.dart';
import '../datasources/change_service_remote_data_source.dart';
import '../mappers/change_service_mapper.dart';
import '../mappers/service_mapper.dart';
import '../mappers/availability_mapper.dart';

class ChangeServiceRepositoryImpl implements ChangeServiceRepository {
  final ChangeServiceRemoteDataSource remoteDataSource;

  ChangeServiceRepositoryImpl(this.remoteDataSource);

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
  Future<ChangeServiceResponse> changeService(
    String appointmentId,
    ChangeServiceRequest request,
  ) async {
    try {
      final requestModel = ChangeServiceMapper.toRequestModel(request);
      final responseModel = await remoteDataSource.changeService(
        appointmentId,
        requestModel,
      );
      return ChangeServiceMapper.toResponseEntity(responseModel);
    } catch (e) {
      throw Exception('Error en repositorio al cambiar servicio: $e');
    }
  }
}

import '../../domain/entities/appointment.dart';
import '../../domain/repositories/appointments_repository.dart';
import '../datasources/appointments_remote_data_source.dart';
import '../mappers/appointments_mapper.dart';

class AppointmentsRepositoryImpl implements AppointmentsRepository {
  final AppointmentsRemoteDataSource remoteDataSource;

  AppointmentsRepositoryImpl(this.remoteDataSource);

  @override
  Future<AppointmentsResponse> getAppointments({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final model = await remoteDataSource.getAppointments(
        page: page,
        limit: limit,
      );
      return AppointmentsMapper.toEntity(model);
    } catch (e) {
      throw Exception('Error en repositorio al obtener citas: $e');
    }
  }
}

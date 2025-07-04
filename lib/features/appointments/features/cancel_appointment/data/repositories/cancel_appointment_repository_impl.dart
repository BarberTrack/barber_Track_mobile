import '../../domain/entities/cancel_appointment_request.dart';
import '../../domain/entities/cancel_appointment_response.dart';
import '../../domain/repositories/cancel_appointment_repository.dart';
import '../datasources/cancel_appointment_remote_data_source.dart';
import '../models/cancel_appointment_request_model.dart';
import '../mappers/cancel_appointment_mapper.dart';

class CancelAppointmentRepositoryImpl implements CancelAppointmentRepository {
  final CancelAppointmentRemoteDataSource remoteDataSource;

  CancelAppointmentRepositoryImpl(this.remoteDataSource);

  @override
  Future<CancelAppointmentResponse> cancelAppointment(
    CancelAppointmentRequest request,
  ) async {
    try {
      final requestModel = CancelAppointmentRequestModel.fromEntity(request);

      final responseModel = await remoteDataSource.cancelAppointment(
        request.appointmentId,
        requestModel,
      );

      return CancelAppointmentMapper.modelToEntity(responseModel);
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }
}

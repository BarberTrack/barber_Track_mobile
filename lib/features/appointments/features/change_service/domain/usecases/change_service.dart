import '../entities/change_service_request.dart';
import '../entities/change_service_response.dart';
import '../repositories/change_service_repository.dart';

class ChangeService {
  final ChangeServiceRepository repository;

  ChangeService(this.repository);

  Future<ChangeServiceResponse> call(
    String appointmentId,
    ChangeServiceRequest request,
  ) {
    return repository.changeService(appointmentId, request);
  }
}

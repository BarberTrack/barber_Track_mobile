import '../entities/change_service_request.dart';
import '../entities/change_service_response.dart';
import '../../../create_appointment/domain/entities/service.dart';
import '../../../create_appointment/domain/entities/availability.dart';

abstract class ChangeServiceRepository {
  Future<List<Service>> getBusinessServices(String businessId);

  Future<List<Availability>> getAvailability({
    required String businessId,
    required String barberId,
    required String date,
    int days = 1,
  });

  Future<ChangeServiceResponse> changeService(
    String appointmentId,
    ChangeServiceRequest request,
  );
}

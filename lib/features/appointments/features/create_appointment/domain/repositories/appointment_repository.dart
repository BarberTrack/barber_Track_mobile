import '../entities/service.dart';
import '../entities/availability.dart';
import '../entities/appointment.dart';

abstract class AppointmentRepository {
  Future<List<Service>> getBusinessServices(String businessId);
  Future<List<Availability>> getAvailability({
    required String businessId,
    required String barberId,
    required String date,
    int days = 1,
  });

  Future<CreateAppointmentResponse> createAppointment(
    CreateAppointmentRequest request,
  );
}

import '../entities/availability.dart';
import '../entities/update_appointment.dart';

abstract class UpdateAppointmentRepository {
  Future<List<Availability>> getAvailability({
    required String businessId,
    required String barberId,
    required String serviceId,
    required String date,
    int days = 3,
  });

  Future<UpdateAppointmentResponse> updateAppointment(
    UpdateAppointmentRequest request,
  );
}

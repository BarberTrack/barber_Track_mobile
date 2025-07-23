import '../entities/availability.dart';
import '../entities/repeat_appointment.dart';

abstract class RepeatAppointmentRepository {
  Future<AvailabilityResponse> getBusinessAvailability({
    required String businessId,
    required String barberId,
    required String serviceId,
    required String date,
    int days = 3,
  });

  Future<RepeatAppointmentResponse> repeatAppointment(
    RepeatAppointmentRequest request,
  );
}

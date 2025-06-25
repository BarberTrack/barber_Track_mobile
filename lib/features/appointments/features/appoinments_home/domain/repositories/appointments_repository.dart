import '../entities/appointment.dart';

abstract class AppointmentsRepository {
  Future<AppointmentsResponse> getAppointments({int page = 1, int limit = 10});
}

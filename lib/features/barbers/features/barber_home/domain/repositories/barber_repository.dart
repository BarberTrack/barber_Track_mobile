import '../entities/barber.dart';

abstract class BarberRepository {
  Future<List<Barber>> getBarbersByBusinessId(String businessId);
}

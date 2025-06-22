import '../entities/barber_business.dart';

abstract class BarberDetailsRepository {
  Future<BarberBusiness> getBusinessById(String businessId);
}

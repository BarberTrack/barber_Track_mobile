import '../entities/barber_business.dart';
import '../repositories/barber_details_repository.dart';

class GetBusinessById {
  final BarberDetailsRepository repository;

  GetBusinessById(this.repository);

  Future<BarberBusiness> call(String businessId) async {
    return await repository.getBusinessById(businessId);
  }
}

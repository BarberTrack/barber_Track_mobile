import '../entities/barber.dart';
import '../repositories/barber_repository.dart';

class GetBarbers {
  final BarberRepository repository;

  GetBarbers(this.repository);

  Future<List<Barber>> call(String businessId) async {
    return await repository.getBarbersByBusinessId(businessId);
  }
}

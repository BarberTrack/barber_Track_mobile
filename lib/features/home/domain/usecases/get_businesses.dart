import '../entities/business.dart';
import '../repositories/home_repository.dart';

class GetBusinesses {
  final HomeRepository repository;

  GetBusinesses(this.repository);

  Future<List<Business>> call() async {
    return await repository.getBusinesses();
  }
}

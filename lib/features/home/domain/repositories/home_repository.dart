import '../entities/business.dart';

abstract class HomeRepository {
  Future<List<Business>> getBusinesses();
}

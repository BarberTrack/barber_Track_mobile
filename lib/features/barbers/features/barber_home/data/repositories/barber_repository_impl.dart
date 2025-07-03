import '../../domain/entities/barber.dart';
import '../../domain/repositories/barber_repository.dart';
import '../datasources/barber_remote_data_source.dart';
import '../mappers/barber_mapper.dart';

class BarberRepositoryImpl implements BarberRepository {
  final BarberRemoteDataSource remoteDataSource;

  BarberRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Barber>> getBarbersByBusinessId(String businessId) async {
    try {
      final barberModels = await remoteDataSource.getBarbersByBusinessId(
        businessId,
      );
      return BarberMapper.toEntityList(barberModels);
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }
}

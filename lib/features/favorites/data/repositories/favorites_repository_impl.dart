import '../../domain/entities/favorites_response.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_remote_data_source.dart';
import '../mappers/favorites_mapper.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesRemoteDataSource remoteDataSource;

  FavoritesRepositoryImpl(this.remoteDataSource);

  @override
  Future<FavoritesResponse> getFavorites() async {
    final responseModel = await remoteDataSource.getFavorites();
    return FavoritesMapper.toEntity(responseModel);
  }
}

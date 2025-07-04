import '../../domain/entities/favorites_response.dart';
import '../../domain/entities/add_favorite_response.dart';
import '../../domain/entities/remove_favorite_response.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_remote_data_source.dart';
import '../mappers/favorites_mapper.dart';
import '../mappers/add_favorite_mapper.dart';
import '../mappers/remove_favorite_mapper.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesRemoteDataSource remoteDataSource;

  FavoritesRepositoryImpl(this.remoteDataSource);

  @override
  Future<FavoritesResponse> getFavorites() async {
    final responseModel = await remoteDataSource.getFavorites();
    return FavoritesMapper.toEntity(responseModel);
  }

  @override
  Future<AddFavoriteResponse> addToFavorites(String businessId) async {
    try {
      final addFavoriteModel = await remoteDataSource.addToFavorites(
        businessId,
      );
      return AddFavoriteMapper.toEntity(addFavoriteModel);
    } catch (e) {
      throw Exception('Error al agregar favorito: $e');
    }
  }

  @override
  Future<RemoveFavoriteResponse> removeFromFavorites(String businessId) async {
    try {
      final removeFavoriteModel = await remoteDataSource.removeFromFavorites(
        businessId,
      );
      return RemoveFavoriteMapper.toEntity(removeFavoriteModel);
    } catch (e) {
      throw Exception('Error al quitar favorito: $e');
    }
  }
}

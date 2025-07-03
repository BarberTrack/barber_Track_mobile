import '../entities/favorites_response.dart';
import '../repositories/favorites_repository.dart';

class GetFavorites {
  final FavoritesRepository repository;

  GetFavorites(this.repository);

  Future<FavoritesResponse> execute() async {
    return await repository.getFavorites();
  }
}

import '../entities/remove_favorite_response.dart';
import '../repositories/favorites_repository.dart';

class RemoveFromFavorites {
  final FavoritesRepository repository;

  RemoveFromFavorites(this.repository);

  Future<RemoveFavoriteResponse> execute(String businessId) async {
    return await repository.removeFromFavorites(businessId);
  }
}

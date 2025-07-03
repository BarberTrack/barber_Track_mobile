import '../entities/add_favorite_response.dart';
import '../repositories/favorites_repository.dart';

class AddToFavorites {
  final FavoritesRepository repository;

  AddToFavorites(this.repository);

  Future<AddFavoriteResponse> execute(String businessId) async {
    return await repository.addToFavorites(businessId);
  }
}

import '../entities/favorites_response.dart';
import '../entities/add_favorite_response.dart';
import '../entities/remove_favorite_response.dart';

abstract class FavoritesRepository {
  Future<FavoritesResponse> getFavorites();
  Future<AddFavoriteResponse> addToFavorites(String businessId);
  Future<RemoveFavoriteResponse> removeFromFavorites(String businessId);
}

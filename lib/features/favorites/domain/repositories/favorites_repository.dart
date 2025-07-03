import '../entities/favorites_response.dart';

abstract class FavoritesRepository {
  Future<FavoritesResponse> getFavorites();
}

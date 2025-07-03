import 'package:shared_preferences/shared_preferences.dart';

class FavoritesStorage {
  static const String _favoritesKey = 'favorite_business_ids';

  // Guardar lista de businessIds favoritos
  Future<void> saveFavoriteBusinessIds(List<String> businessIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoritesKey, businessIds);
  }

  // Obtener lista de businessIds favoritos
  Future<List<String>> getFavoriteBusinessIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoritesKey) ?? [];
  }

  // Agregar un businessId a favoritos
  Future<void> addFavoriteBusinessId(String businessId) async {
    final currentFavorites = await getFavoriteBusinessIds();
    if (!currentFavorites.contains(businessId)) {
      currentFavorites.add(businessId);
      await saveFavoriteBusinessIds(currentFavorites);
    }
  }

  // Quitar un businessId de favoritos
  Future<void> removeFavoriteBusinessId(String businessId) async {
    final currentFavorites = await getFavoriteBusinessIds();
    currentFavorites.remove(businessId);
    await saveFavoriteBusinessIds(currentFavorites);
  }

  // Verificar si un businessId está en favoritos
  Future<bool> isFavorite(String businessId) async {
    final favoriteIds = await getFavoriteBusinessIds();
    return favoriteIds.contains(businessId);
  }

  // Limpiar todos los favoritos (útil para logout)
  Future<void> clearFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_favoritesKey);
  }

  // Sincronizar con lista de favoritos del servidor
  Future<void> syncWithServerFavorites(List<String> serverFavoriteIds) async {
    await saveFavoriteBusinessIds(serverFavoriteIds);
  }
}

import 'package:shared_preferences/shared_preferences.dart';

class FavoritesStorage {
  static const String _favoritesKey = 'favorite_business_ids';

  
  Future<void> saveFavoriteBusinessIds(List<String> businessIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoritesKey, businessIds);
  }

  
  Future<List<String>> getFavoriteBusinessIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoritesKey) ?? [];
  }

  
  Future<void> addFavoriteBusinessId(String businessId) async {
    final currentFavorites = await getFavoriteBusinessIds();
    if (!currentFavorites.contains(businessId)) {
      currentFavorites.add(businessId);
      await saveFavoriteBusinessIds(currentFavorites);
    }
  }

  
  Future<void> removeFavoriteBusinessId(String businessId) async {
    final currentFavorites = await getFavoriteBusinessIds();
    currentFavorites.remove(businessId);
    await saveFavoriteBusinessIds(currentFavorites);
  }

  
  Future<bool> isFavorite(String businessId) async {
    final favoriteIds = await getFavoriteBusinessIds();
    return favoriteIds.contains(businessId);
  }

  
  Future<void> clearFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_favoritesKey);
  }

  
  Future<void> syncWithServerFavorites(List<String> serverFavoriteIds) async {
    await saveFavoriteBusinessIds(serverFavoriteIds);
  }
}

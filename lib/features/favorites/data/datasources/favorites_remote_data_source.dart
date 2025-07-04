import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/storage/token_storage.dart';
import '../models/favorites_response_model.dart';
import '../models/add_favorite_response_model.dart';
import '../models/remove_favorite_response_model.dart';

abstract class FavoritesRemoteDataSource {
  Future<FavoritesResponseModel> getFavorites();
  Future<AddFavoriteResponseModel> addToFavorites(String businessId);
  Future<RemoveFavoriteResponseModel> removeFromFavorites(String businessId);
}

class FavoritesRemoteDataSourceImpl implements FavoritesRemoteDataSource {
  final DioClient dioClient;
  final TokenStorage tokenStorage;

  FavoritesRemoteDataSourceImpl(this.dioClient, this.tokenStorage);

  @override
  Future<FavoritesResponseModel> getFavorites() async {
    try {
      final token = await tokenStorage.getToken();

      final response = await dioClient.dio.get(
        '/favorites',
        options: Options(
          headers: {if (token != null) 'Authorization': 'Bearer $token'},
        ),
      );
      
      if (response.statusCode == 200) {
        return FavoritesResponseModel.fromJson(response.data);
      } else {
        throw Exception('Error al obtener favoritos: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Error del servidor: ${e.response?.statusMessage}');
      } else {
        throw Exception('Error de conexión: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  @override
  Future<AddFavoriteResponseModel> addToFavorites(String businessId) async {
    try {
      final token = await tokenStorage.getToken();

      final response = await dioClient.dio.post(
        '/favorites/$businessId',
        queryParameters: {'businessId': businessId},
        options: Options(
          headers: {if (token != null) 'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 201) {
        return AddFavoriteResponseModel.fromJson(response.data);
      } else {
        throw Exception('Error al agregar favorito: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 500) {
          throw Exception('Espera y vuelve a intentarlo');
        }
        throw Exception('Error del servidor: ${e.response?.statusMessage}');
      } else {
        throw Exception('Error de conexión: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  @override
  Future<RemoveFavoriteResponseModel> removeFromFavorites(
    String businessId,
  ) async {
    try {
      final token = await tokenStorage.getToken();

      final response = await dioClient.dio.delete(
        '/favorites/$businessId',
        queryParameters: {'businessId': businessId},
        options: Options(
          headers: {if (token != null) 'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        return RemoveFavoriteResponseModel.fromJson(response.data);
      } else {
        throw Exception('Error al quitar favorito: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 500) {
          throw Exception('Espera y vuelve a intentarlo');
        }
        throw Exception('Error del servidor: ${e.response?.statusMessage}');
      } else {
        throw Exception('Error de conexión: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }
}

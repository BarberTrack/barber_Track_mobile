import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/storage/token_storage.dart';
import '../models/favorites_response_model.dart';

abstract class FavoritesRemoteDataSource {
  Future<FavoritesResponseModel> getFavorites();
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
}

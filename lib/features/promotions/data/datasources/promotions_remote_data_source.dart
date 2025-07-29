import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/storage/token_storage.dart';
import '../models/promotions_response_model.dart';

abstract class PromotionsRemoteDataSource {
  Future<PromotionsResponseModel> getBusinessPromotions(String businessId);
}

class PromotionsRemoteDataSourceImpl implements PromotionsRemoteDataSource {
  final DioClient dioClient;
  final TokenStorage tokenStorage;

  PromotionsRemoteDataSourceImpl(this.dioClient, this.tokenStorage);

  @override
  Future<PromotionsResponseModel> getBusinessPromotions(String businessId) async {
    try {
      final token = await tokenStorage.getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token de autenticación no encontrado');
      }

      final response = await dioClient.dio.get(
        '/businesses/$businessId/promotions',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return PromotionsResponseModel.fromJson(response.data);
      } else {
        throw Exception('Error al obtener promociones: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('No autorizado. Inicia sesión nuevamente.');
      } else if (e.response?.statusCode == 404) {
        throw Exception('No se encontraron promociones para este negocio');
      } else if (e.response?.statusCode == 500) {
        throw Exception('Error interno del servidor');
      } else {
        throw Exception('Error de conexión: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }
} 
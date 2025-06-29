import 'package:dio/dio.dart';
import '../../../../../../core/network/dio_client.dart';
import '../../../../../../core/storage/token_storage.dart';
import '../models/style_history_model.dart';

abstract class StyleHistoryRemoteDataSource {
  Future<StyleHistoryModel> getStyleHistory();
}

class StyleHistoryRemoteDataSourceImpl implements StyleHistoryRemoteDataSource {
  final DioClient dioClient;
  final TokenStorage tokenStorage;

  StyleHistoryRemoteDataSourceImpl(this.dioClient, this.tokenStorage);

  @override
  Future<StyleHistoryModel> getStyleHistory() async {
    try {
      final token = await tokenStorage.getToken();

      final response = await dioClient.dio.get(
        '/api/style/history',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as Map<String, dynamic>;
        return StyleHistoryModel.fromJson(data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Error al obtener el historial de estilos',
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Token de autorización inválido');
      } else if (e.response?.statusCode == 404) {
        throw Exception('No se encontró historial de estilos');
      } else {
        throw Exception(e.message ?? 'Error de conexión');
      }
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }
}

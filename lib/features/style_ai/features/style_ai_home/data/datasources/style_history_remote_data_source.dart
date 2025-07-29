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
        if (response.data == null) {
          throw Exception('La respuesta del servidor está vacía');
        }

        final responseData = response.data;
        if (responseData is! Map<String, dynamic>) {
          throw Exception('Formato de respuesta inválido del servidor');
        }

        final data = responseData['data'];
        if (data == null) {
          return const StyleHistoryModel(
            analyses: [],
            totalCount: 0,
            hasMore: false,
            dailyUsage: DailyUsageModel(
              usedToday: 0,
              remainingToday: 5,
              resetTime: '',
            ),
          );
        }

        if (data is! Map<String, dynamic>) {
          throw Exception('Los datos recibidos tienen formato inválido');
        }

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
        return const StyleHistoryModel(
          analyses: [],
          totalCount: 0,
          hasMore: false,
          dailyUsage: DailyUsageModel(
            usedToday: 0,
            remainingToday: 5,
            resetTime: '',
          ),
        );
      } else {
        throw Exception(e.message ?? 'Error de conexión');
      }
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }
}

import 'package:dio/dio.dart';
import '../models/business_model.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/storage/token_storage.dart';
import 'package:logger/logger.dart';

abstract class HomeRemoteDataSource {
  Future<List<BusinessModel>> getBusinesses();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final DioClient dioClient;
  final TokenStorage tokenStorage;
  final Logger logger = Logger();

  HomeRemoteDataSourceImpl(this.dioClient, this.tokenStorage);

  @override
  Future<List<BusinessModel>> getBusinesses() async {
    try {
      // Obtener el token del almacenamiento
      final token = await tokenStorage.getToken();

      if (token == null) {
        throw Exception('No authentication token found');
      }

      // Configurar el header de autorización
      final response = await dioClient.dio.get(
        '/businesses',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      //logger.d(response);
      if (response.statusCode == 200) {
        final data = response.data;
        final businessesData = data['data']['businesses'] as List<dynamic>;

        return businessesData
            .map((businessJson) => BusinessModel.fromJson(businessJson))
            .toList();
      } else {
        throw Exception('Failed to load businesses: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}

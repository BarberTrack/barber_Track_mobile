import 'package:dio/dio.dart';
import '../models/map_businesses_response_model.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/storage/token_storage.dart';
import 'package:logger/logger.dart';

abstract class MapRemoteDataSource {
  Future<MapBusinessesResponseModel> getBusinesses();
}

class MapRemoteDataSourceImpl implements MapRemoteDataSource {
  final DioClient dioClient;
  final TokenStorage tokenStorage;
  final Logger logger = Logger();

  MapRemoteDataSourceImpl(this.dioClient, this.tokenStorage);

  @override
  Future<MapBusinessesResponseModel> getBusinesses() async {
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

      logger.i('Map businesses request - Status: ${response.statusCode}');
      logger.d('Map businesses response: ${response.data}');

      if (response.statusCode == 200) {
        // Imprimir los negocios obtenidos en consola
        final data = response.data;
        logger.i(
          'Total de negocios obtenidos para el mapa: ${data['data']['total']}',
        );

        final businessesData = data['data']['businesses'] as List<dynamic>;
        for (int i = 0; i < businessesData.length; i++) {
          final business = businessesData[i];
          logger.i(
            'Negocio ${i + 1}: ${business['name']} - ${business['address']}',
          );
          if (business['latitude'] != null && business['longitude'] != null) {
            logger.i(
              '  Coordenadas: ${business['latitude']}, ${business['longitude']}',
            );
          } else {
            logger.w('  Sin coordenadas disponibles');
          }
        }

        return MapBusinessesResponseModel.fromJson(response.data);
      } else {
        throw Exception(
          'Failed to load map businesses: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      logger.e('Network error getting map businesses: ${e.message}');
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      logger.e('Unexpected error getting map businesses: $e');
      throw Exception('Unexpected error: $e');
    }
  }
}

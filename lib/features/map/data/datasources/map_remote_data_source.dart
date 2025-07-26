import 'package:dio/dio.dart';
import '../models/map_businesses_response_model.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/storage/token_storage.dart';
import '../../domain/entities/map_business_filters.dart';

abstract class MapRemoteDataSource {
  Future<MapBusinessesResponseModel> getBusinesses();
  Future<MapBusinessesResponseModel> getBusinessesWithFilters(
    MapBusinessFilters filters,
  );
}

class MapRemoteDataSourceImpl implements MapRemoteDataSource {
  final DioClient dioClient;
  final TokenStorage tokenStorage;

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

      if (response.statusCode == 200) {
        return MapBusinessesResponseModel.fromJson(response.data);
      } else {
        throw Exception(
          'Failed to load map businesses: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<MapBusinessesResponseModel> getBusinessesWithFilters(
    MapBusinessFilters filters,
  ) async {
    try {
      // Obtener el token del almacenamiento
      final token = await tokenStorage.getToken();

      if (token == null) {
        throw Exception('No authentication token found');
      }

      // Convertir filtros a parámetros de consulta
      final queryParameters = filters.toQueryParameters();

      // Configurar el header de autorización
      final response = await dioClient.dio.get(
        '/businesses',
        queryParameters: queryParameters,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return MapBusinessesResponseModel.fromJson(response.data);
      } else {
        throw Exception(
          'Failed to load map businesses with filters: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}

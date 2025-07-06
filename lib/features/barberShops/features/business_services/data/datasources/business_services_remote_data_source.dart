import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../models/business_services_response_model.dart';
import '../../../../../../core/network/dio_client.dart';
import '../../../../../../core/storage/token_storage.dart';

abstract class BusinessServicesRemoteDataSource {
  Future<BusinessServicesResponseModel> getBusinessServices(String businessId);
}

class BusinessServicesRemoteDataSourceImpl
    implements BusinessServicesRemoteDataSource {
  final DioClient dioClient;
  final TokenStorage tokenStorage;
  final Logger logger = Logger();

  BusinessServicesRemoteDataSourceImpl(this.dioClient, this.tokenStorage);

  @override
  Future<BusinessServicesResponseModel> getBusinessServices(
    String businessId,
  ) async {
    try {
      final token = await tokenStorage.getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await dioClient.dio.get(
        '/services-business/business/$businessId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return BusinessServicesResponseModel.fromJson(response.data);
      } else {
        throw Exception(
          'Error al obtener servicios del negocio: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      logger.e('Error de red al obtener servicios: $e');
      throw Exception('Error de conexión al obtener servicios: ${e.message}');
    } catch (e) {
      logger.e('Error inesperado al obtener servicios: $e');
      throw Exception('Error inesperado al obtener servicios: $e');
    }
  }
}

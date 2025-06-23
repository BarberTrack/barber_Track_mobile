import '../../../../../../core/network/dio_client.dart';
import '../models/barber_business_model.dart';
import '../../../../../../core/storage/token_storage.dart';
import 'package:logger/logger.dart';
import 'package:dio/dio.dart';

abstract class BarberDetailsRemoteDataSource {
  Future<BarberBusinessModel> getBusinessById(String businessId);
}

class BarberDetailsRemoteDataSourceImpl
    implements BarberDetailsRemoteDataSource {
  final DioClient dioClient;
  final TokenStorage tokenStorage;
  final Logger logger = Logger();
  BarberDetailsRemoteDataSourceImpl(this.dioClient, this.tokenStorage);

  @override
  Future<BarberBusinessModel> getBusinessById(String businessId) async {
    try {
      final token = await tokenStorage.getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }
      final response = await dioClient.dio.get(
        '/businesses/$businessId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final businessData = response.data['data'];
        return BarberBusinessModel.fromJson(businessData);
      } else {
        throw Exception(
          'Error al obtener detalles del negocio: ${response.statusCode}',
        );
      }
    } catch (e) {
      logger.e('Error detallado: $e');
      throw Exception('Error de red al obtener detalles del negocio: $e');
    }
  }
}

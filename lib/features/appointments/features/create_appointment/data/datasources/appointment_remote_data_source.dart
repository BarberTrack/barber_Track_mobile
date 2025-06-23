import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../../../../../core/network/dio_client.dart';
import '../../../../../../core/storage/token_storage.dart';
import '../models/service_model.dart';
import '../models/availability_model.dart';

abstract class AppointmentRemoteDataSource {
  Future<List<ServiceModel>> getBusinessServices(String businessId);
  Future<List<AvailabilityModel>> getAvailability({
    required String businessId,
    required String barberId,
    required String date,
    int days = 1,
  });
}

class AppointmentRemoteDataSourceImpl implements AppointmentRemoteDataSource {
  final DioClient dioClient;
  final TokenStorage tokenStorage;
  final Logger logger = Logger();

  AppointmentRemoteDataSourceImpl(this.dioClient, this.tokenStorage);

  @override
  Future<List<ServiceModel>> getBusinessServices(String businessId) async {
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
        final data = response.data['data'];
        final services = data['services'] as List<dynamic>;

        return services
            .map(
              (service) =>
                  ServiceModel.fromJson(service as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw Exception('Error al obtener servicios: ${response.statusCode}');
      }
    } catch (e) {
      logger.e('Error obteniendo servicios del negocio: $e');
      throw Exception('Error de red al obtener servicios: $e');
    }
  }

  @override
  Future<List<AvailabilityModel>> getAvailability({
    required String businessId,
    required String barberId,
    required String date,
    int days = 1,
  }) async {
    try {
      final token = await tokenStorage.getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await dioClient.dio.get(
        '/availability',
        queryParameters: {
          'businessId': businessId,
          'barberId': barberId,
          'date': date,
          'days': days,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      //logger.d(response.data);
      if (response.statusCode == 200) {
        final data = response.data['data'];
        final availability = data['availability'] as List<dynamic>;

        return availability
            .map(
              (item) =>
                  AvailabilityModel.fromJson(item as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw Exception(
          'Error al obtener disponibilidad: ${response.statusCode}',
        );
      }
    } catch (e) {
      logger.e('Error obteniendo disponibilidad: $e');
      throw Exception('Error de red al obtener disponibilidad: $e');
    }
  }
}

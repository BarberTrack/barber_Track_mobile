import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../../../../../core/network/dio_client.dart';
import '../../../../../../core/storage/token_storage.dart';
import '../models/change_service_request_model.dart';
import '../models/change_service_response_model.dart';
import '../../../create_appointment/data/models/service_model.dart';
import '../../../create_appointment/data/models/availability_model.dart';

abstract class ChangeServiceRemoteDataSource {
  Future<List<ServiceModel>> getBusinessServices(String businessId);

  Future<List<AvailabilityModel>> getAvailability({
    required String businessId,
    required String barberId,
    required String date,
    int days = 1,
  });

  Future<ChangeServiceResponseModel> changeService(
    String appointmentId,
    ChangeServiceRequestModel request,
  );
}

class ChangeServiceRemoteDataSourceImpl
    implements ChangeServiceRemoteDataSource {
  final DioClient dioClient;
  final TokenStorage tokenStorage;
  final Logger logger = Logger();

  ChangeServiceRemoteDataSourceImpl(this.dioClient, this.tokenStorage);

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
          'days': 1,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

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

  @override
  Future<ChangeServiceResponseModel> changeService(
    String appointmentId,
    ChangeServiceRequestModel request,
  ) async {
    try {
      final token = await tokenStorage.getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      logger.d(
        'Changing service for appointment $appointmentId with data: ${request.toJson()}',
      );

      final response = await dioClient.dio.put(
        '/appointments/$appointmentId',
        data: request.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      // logger.d(
      //   'Change service response: ${response.statusCode} - ${response.data}',
      // );

      if (response.statusCode == 200) {
        return ChangeServiceResponseModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw Exception('Error al cambiar servicio: ${response.statusCode}');
      }
    } catch (e) {
      logger.e('Error cambiando servicio: $e');
      if (e is DioException) {
        if (e.response != null) {
          final errorData = e.response!.data;
          if (errorData is Map<String, dynamic> &&
              errorData.containsKey('message')) {
            throw Exception(errorData['message']);
          }
        }
      }
      throw Exception('Error de red al cambiar servicio: $e');
    }
  }
}

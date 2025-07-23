import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../../../../../core/network/dio_client.dart';
import '../../../../../../core/storage/token_storage.dart';
import '../models/availability_model.dart';
import '../models/update_appointment_request_model.dart';
import '../models/update_appointment_response_model.dart';

abstract class UpdateAppointmentRemoteDataSource {
  Future<List<AvailabilityModel>> getAvailability({
    required String businessId,
    required String barberId,
    required String serviceId,
    required String date,
    int days = 3,
  });

  Future<UpdateAppointmentResponseModel> updateAppointment(
    String appointmentId,
    UpdateAppointmentRequestModel request,
  );
}

class UpdateAppointmentRemoteDataSourceImpl
    implements UpdateAppointmentRemoteDataSource {
  final DioClient dioClient;
  final TokenStorage tokenStorage;
  final Logger logger = Logger();

  UpdateAppointmentRemoteDataSourceImpl(this.dioClient, this.tokenStorage);

  @override
  Future<List<AvailabilityModel>> getAvailability({
    required String businessId,
    required String barberId,
    required String serviceId,
    required String date,
    int days = 3,
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
          'serviceId': serviceId,
          'date': date,
          'days': days,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      logger.d('Availability response: ${response.data}');

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
  Future<UpdateAppointmentResponseModel> updateAppointment(
    String appointmentId,
    UpdateAppointmentRequestModel request,
  ) async {
    try {
      final token = await tokenStorage.getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      logger.d(
        'Updating appointment $appointmentId with data: ${request.toJson()}',
      );

      final response = await dioClient.dio.put(
        '/appointments/$appointmentId',
        data: request.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      logger.d(
        'Update appointment response: ${response.statusCode} - ${response.data}',
      );

      if (response.statusCode == 200) {
        return UpdateAppointmentResponseModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw Exception('Error al actualizar cita: ${response.statusCode}');
      }
    } catch (e) {
      logger.e('Error actualizando cita: $e');
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          final errorData = e.response!.data;

          String errorMessage = 'Error al actualizar la cita';

          switch (statusCode) {
            case 400:
              errorMessage = 'Datos de entrada inválidos';
              break;
            case 403:
              errorMessage =
                  'No se puede modificar la cita (muy cerca de la fecha programada)';
              break;
            case 404:
              errorMessage = 'Cita no encontrada o sin permisos';
              break;
            default:
              if (errorData is Map<String, dynamic> &&
                  errorData.containsKey('message')) {
                errorMessage = errorData['message'];
              }
          }

          throw DioException(
            requestOptions: e.requestOptions,
            response: e.response,
            error: errorMessage,
          );
        }
      }
      throw Exception('Error de red al actualizar cita: $e');
    }
  }
}

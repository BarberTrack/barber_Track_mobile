import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/storage/token_storage.dart';
import '../models/availability_response_model.dart';
import '../models/repeat_appointment_request_model.dart';
import '../models/repeat_appointment_response_model.dart';

abstract class RepeatAppointmentRemoteDataSource {
  Future<AvailabilityDataModel> getBusinessAvailability({
    required String businessId,
    required String barberId,
    required String serviceId,
    required String date,
    int days = 3,
  });

  Future<RepeatAppointmentResponseModel> repeatAppointment(
    String appointmentId,
    RepeatAppointmentRequestModel request,
  );
}

class RepeatAppointmentRemoteDataSourceImpl
    implements RepeatAppointmentRemoteDataSource {
  final DioClient dioClient;
  final TokenStorage tokenStorage;
  final Logger logger = Logger();

  RepeatAppointmentRemoteDataSourceImpl(this.dioClient, this.tokenStorage);

  @override
  Future<AvailabilityDataModel> getBusinessAvailability({
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
 

      if (response.statusCode == 200) {
        final availabilityResponse = AvailabilityResponseModel.fromJson(
          response.data as Map<String, dynamic>,
        );
        return availabilityResponse.data;
      } else {
        throw Exception(
          'Error al obtener disponibilidad: ${response.statusCode}',
        );
      }
    } catch (e) {
       
      if (e is DioException) {
        if (e.response != null) {
          final errorData = e.response!.data;
          if (errorData is Map<String, dynamic> &&
              errorData.containsKey('message')) {
            throw Exception(errorData['message']);
          }
        }
      }
      throw Exception('Error de red al obtener disponibilidad: $e');
    }
  }

  @override
  Future<RepeatAppointmentResponseModel> repeatAppointment(
    String appointmentId,
    RepeatAppointmentRequestModel request,
  ) async {
    try {
      final token = await tokenStorage.getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

 
      final response = await dioClient.dio.post(
        '/appointments/$appointmentId/repeat',
        data: request.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

 

      if (response.statusCode == 201) {
        return RepeatAppointmentResponseModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw Exception('Error al repetir cita: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          if (statusCode == 400) {
            throw Exception('Datos de entrada inválidos o fecha no disponible');
          } else if (statusCode == 409) {
            throw Exception('Conflicto de horario en la fecha seleccionada');
          }

          final errorData = e.response!.data;
          if (errorData is Map<String, dynamic> &&
              errorData.containsKey('message')) {
            throw Exception(errorData['message']);
          }
        }
      }
      throw Exception('Error de red al repetir cita: $e');
    }
  }
}

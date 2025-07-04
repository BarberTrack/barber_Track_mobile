import 'package:dio/dio.dart';
import '../../../../../../core/network/dio_client.dart';
import '../../../../../../core/storage/token_storage.dart';
import '../models/cancel_appointment_request_model.dart';
import '../models/cancel_appointment_response_model.dart';
import 'package:logger/logger.dart';

abstract class CancelAppointmentRemoteDataSource {
  Future<CancelAppointmentResponseModel> cancelAppointment(
    String appointmentId,
    CancelAppointmentRequestModel request,
  );
}

class CancelAppointmentRemoteDataSourceImpl
    implements CancelAppointmentRemoteDataSource {
  final DioClient dioClient;
  final TokenStorage tokenStorage;
  final Logger logger;
  CancelAppointmentRemoteDataSourceImpl(
    this.dioClient,
    this.tokenStorage,
    this.logger,
  );

  @override
  Future<CancelAppointmentResponseModel> cancelAppointment(
    String appointmentId,
    CancelAppointmentRequestModel request,
  ) async {
    try {
      final token = await tokenStorage.getToken();

      if (token == null) {
        throw Exception('No auth token found');
      }

      final response = await dioClient.dio.delete(
        '/appointments/$appointmentId/cancel',
        data: request.toJson(),
        queryParameters: {'appointmentId': appointmentId},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      //logger.d(response.data);
      if (response.statusCode == 200) {
        return CancelAppointmentResponseModel.fromJson(response.data);
      } else {
        throw Exception('Failed to cancel appointment: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          'Error cancelling appointment: ${e.response?.data['message'] ?? e.message}',
        );
      } else {
        throw Exception('Connection error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}

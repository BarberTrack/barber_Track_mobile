import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../../../../../core/network/dio_client.dart';
import '../../../../../../core/storage/token_storage.dart';
import '../models/appointments_response_model.dart';

abstract class AppointmentsRemoteDataSource {
  Future<AppointmentsResponseModel> getAppointments({
    int page = 1,
    int limit = 10,
    String? status,
  });
}

class AppointmentsRemoteDataSourceImpl implements AppointmentsRemoteDataSource {
  final DioClient dioClient;
  final TokenStorage tokenStorage;
  final Logger logger = Logger();

  AppointmentsRemoteDataSourceImpl(this.dioClient, this.tokenStorage);

  @override
  Future<AppointmentsResponseModel> getAppointments({
    int page = 1,
    int limit = 10,
    String? status,
  }) async {
    try {
      final token = await tokenStorage.getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final queryParameters = <String, dynamic>{'page': page, 'limit': limit};

      if (status != null && status.isNotEmpty) {
        queryParameters['status'] = status;
      }

      //logger.d('Getting appointments with params: $queryParameters');

      final response = await dioClient.dio.get(
        '/appointments',
        queryParameters: queryParameters,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      // logger.d(
      //   'Get appointments response: ${response.statusCode} - ${response.data}',
      // );

      if (response.statusCode == 200) {
        return AppointmentsResponseModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw Exception('Error al obtener citas: ${response.statusCode}');
      }
    } catch (e) {
      logger.e('Error obteniendo citas: $e');
      if (e is DioException) {
        if (e.response != null) {
          final errorData = e.response!.data;
          if (errorData is Map<String, dynamic> &&
              errorData.containsKey('message')) {
            throw Exception(errorData['message']);
          }
        }
      }
      throw Exception('Error de red al obtener citas: $e');
    }
  }
}

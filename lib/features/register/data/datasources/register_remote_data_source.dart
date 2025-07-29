import 'package:dio/dio.dart';
import '../models/register_request_model.dart';
import '../models/register_response_model.dart';
import '../../../../core/network/dio_client.dart';

abstract class RegisterRemoteDataSource {
  Future<RegisterResponseModel> registerUser(RegisterRequestModel request);
}

class RegisterRemoteDataSourceImpl implements RegisterRemoteDataSource {
  final DioClient dioClient;

  RegisterRemoteDataSourceImpl(this.dioClient);

  @override
  Future<RegisterResponseModel> registerUser(
    RegisterRequestModel request,
  ) async {
    try {
      final response = await dioClient.dio.post(
        '/auth/register/email',
        data: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return RegisterResponseModel.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Error en el registro',
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        throw DioException(
          requestOptions: e.requestOptions,
          response: e.response,
          message: 'El email ya está registrado',
          type: DioExceptionType.badResponse,
        );
      } else if (e.response?.statusCode == 400) {
        throw DioException(
          requestOptions: e.requestOptions,
          response: e.response,
          message: 'Datos de registro inválidos',
          type: DioExceptionType.badResponse,
        );
      } else {
        throw DioException(
          requestOptions: e.requestOptions,
          response: e.response,
          message: e.message ?? 'Error de conexión',
          type: e.type,
        );
      }
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }
}

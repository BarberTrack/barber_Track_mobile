import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';

abstract class LoginRemoteDataSource {
  Future<LoginResponseModel> authenticate(LoginRequestModel request);
}

class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  final DioClient dioClient;

  LoginRemoteDataSourceImpl(this.dioClient);

  @override
  Future<LoginResponseModel> authenticate(LoginRequestModel request) async {
    try {
      final response = await dioClient.dio.post(
        '/auth/login',
        data: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return LoginResponseModel.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Error en la autenticación',
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw DioException(
          requestOptions: e.requestOptions,
          response: e.response,
          message: 'Credenciales incorrectas',
        );
      }
      throw DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        message: 'Error de conexión',
      );
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/auth/login'),
        message: 'Error inesperado: $e',
      );
    }
  }
}

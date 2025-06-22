import 'package:dio/dio.dart';

class BarberDioClient {
  late final Dio _dio;

  BarberDioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://api-barber-dummie-production.up.railway.app',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
  }

  Dio get dio => _dio;
}

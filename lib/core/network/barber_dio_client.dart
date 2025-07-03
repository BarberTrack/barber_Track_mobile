import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class BarberDioClient {
  late final Dio _dio;

  BarberDioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://api-barber-dummie-production.up.railway.app',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        // sendTimeout no es compatible con Web para requests sin body
        sendTimeout: kIsWeb ? null : const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
  }

  Dio get dio => _dio;
}

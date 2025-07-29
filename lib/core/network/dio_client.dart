import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../config/environment.dart';

class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: Environment.apiBaseUrl,
        connectTimeout: Duration(seconds: Environment.connectTimeout),
        receiveTimeout: Duration(seconds: Environment.receiveTimeout),

        sendTimeout: kIsWeb ? null : Duration(seconds: Environment.sendTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
  }

  Dio get dio => _dio;
}

// ignore_for_file: unused_local_variable

import 'package:logger/logger.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import '../network/dio_client.dart';
import '../storage/token_storage.dart';
import '../di/injection.dart';
import '../../features/favorites/domain/usecases/get_favorites.dart';

class ApiDebugHelper {
  static final Logger _logger = Logger();


  static Future<void> logFileInfo(File file, String description) async {
    try {
    


      if (await file.exists()) {
        final lastModified = await file.lastModified();
        _logger.d('Última modificación: $lastModified');
      }

    } catch (e) {
        throw Exception(e);
    }
  }

  static Future<bool> isValidImageFile(File file) async {
    try {
      if (!await file.exists()) {
 
        return false;
      }

      final fileSize = await file.length();
      const maxSize = 10 * 1024 * 1024; // 10MB
      const minSize = 1024; // 1KB

      if (fileSize > maxSize) {
        return false;
      }

      if (fileSize < minSize) {
        return false;
      }

      final extension = file.path.toLowerCase();
      if (!extension.endsWith('.jpg') &&
          !extension.endsWith('.jpeg') &&
          !extension.endsWith('.png')) {
        _logger.w('Extensión de archivo no soportada: $extension');
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<String> generateDiagnosticReport() async {
    final buffer = StringBuffer();

    buffer.writeln('=== REPORTE DE DIAGNÓSTICO ===');
    buffer.writeln('Timestamp: ${DateTime.now()}');
    buffer.writeln('Platform: ${Platform.operatingSystem}');
    buffer.writeln('Platform Version: ${Platform.operatingSystemVersion}');

    try {
      buffer.writeln('');
      buffer.writeln('=== ALMACENAMIENTO ===');
    } catch (e) {
      buffer.writeln('Error al obtener información del sistema: $e');
    }

    buffer.writeln('========================');

    return buffer.toString();
  }

  static Future<void> testFavoritesApi() async {

    try {
      final dioClient = sl<DioClient>();
      final tokenStorage = sl<TokenStorage>();

      final token = await tokenStorage.getToken();

      if (token != null) {
      }


      final response = await dioClient.dio.get(
        '/favorites',
        options: Options(
          headers: {if (token != null) 'Authorization': 'Bearer $token'},
        ),
      );



      if (response.data != null && response.data['data'] != null) {
        final favorites = response.data['data']['favorites'] as List?;

        if (favorites != null && favorites.isNotEmpty) {
          for (int i = 0; i < favorites.length; i++) {
            
            
          }
        }
      }
    } catch (e) {
        throw Exception(e);
    }

  }

  static Future<void> testFavoritesFullFlow() async {

    try {
      await testFavoritesApi();

      final getFavoritesUseCase = sl<GetFavorites>();
      final response = await getFavoritesUseCase.execute();

      for (int i = 0; i < response.data.favorites.length; i++) {
      }
    } catch (e) {
        throw Exception(e);
    }

  }

  static Future<void> testAddFavorite(String businessId) async {

    try {
      final dioClient = sl<DioClient>();
      final tokenStorage = sl<TokenStorage>();

      final token = await tokenStorage.getToken();

      final response = await dioClient.dio.post(
        '/favorites/$businessId',
        queryParameters: {'businessId': businessId},
        options: Options(
          headers: {if (token != null) 'Authorization': 'Bearer $token'},
        ),
      );

      
      await testFavoritesApi();
    } catch (e) {
        throw Exception(e);
    }

  }
}

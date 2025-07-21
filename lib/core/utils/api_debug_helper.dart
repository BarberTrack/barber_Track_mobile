import 'package:logger/logger.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import '../network/dio_client.dart';
import '../storage/token_storage.dart';
import '../di/injection.dart';
import '../../features/favorites/domain/usecases/get_favorites.dart';

class ApiDebugHelper {
  static final Logger _logger = Logger();

  /// Imprime información detallada sobre un archivo
  static Future<void> logFileInfo(File file, String description) async {
    try {
    


      if (await file.exists()) {
        final lastModified = await file.lastModified();
        _logger.d('Última modificación: $lastModified');
      }

    } catch (e) {
      //_logger.e('Error al obtener información del archivo $description: $e');
    }
  }

  /// Verifica si un archivo es válido para el análisis
  static Future<bool> isValidImageFile(File file) async {
    try {
      if (!await file.exists()) {
        //_logger.w('El archivo no existe: ${file.path}');
        return false;
      }

      final fileSize = await file.length();
      const maxSize = 10 * 1024 * 1024; // 10MB
      const minSize = 1024; // 1KB

      if (fileSize > maxSize) {
        //_logger.w('Archivo demasiado grande: ${fileSize / (1024 * 1024)} MB');
        return false;
      }

      if (fileSize < minSize) {
        //_logger.w('Archivo demasiado pequeño: $fileSize bytes');
        return false;
      }

      // Verificar extensión
      final extension = file.path.toLowerCase();
      if (!extension.endsWith('.jpg') &&
          !extension.endsWith('.jpeg') &&
          !extension.endsWith('.png')) {
        _logger.w('Extensión de archivo no soportada: $extension');
        return false;
      }

      return true;
    } catch (e) {
      //_logger.e('Error al validar archivo: $e');
      return false;
    }
  }

  /// Genera un reporte de diagnóstico del sistema
  static Future<String> generateDiagnosticReport() async {
    final buffer = StringBuffer();

    buffer.writeln('=== REPORTE DE DIAGNÓSTICO ===');
    buffer.writeln('Timestamp: ${DateTime.now()}');
    buffer.writeln('Platform: ${Platform.operatingSystem}');
    buffer.writeln('Platform Version: ${Platform.operatingSystemVersion}');

    try {
      // Verificar espacio de almacenamiento disponible
      buffer.writeln('');
      buffer.writeln('=== ALMACENAMIENTO ===');
      // Nota: En Flutter no hay una API directa para esto, pero podemos verificar operaciones básicas
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
            final fav = favorites[i];

          }
        }
      }
    } catch (e, stackTrace) {

    }

  }

  static Future<void> testFavoritesFullFlow() async {

    try {
      // 1. Test directo de la API
      await testFavoritesApi();

      // 2. Test del use case completo
      final getFavoritesUseCase = sl<GetFavorites>();
      final response = await getFavoritesUseCase.execute();



      // 3. Inspeccionar cada favorito del use case
      for (int i = 0; i < response.data.favorites.length; i++) {
        final fav = response.data.favorites[i];
      }
    } catch (e, stackTrace) {
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


      // Después de agregar, obtener la lista actualizada
      await testFavoritesApi();
    } catch (e, stackTrace) {
    }

  }
}

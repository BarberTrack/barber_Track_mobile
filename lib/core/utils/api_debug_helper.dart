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
      final fileSize = await file.length();
      final fileSizeInMB = fileSize / (1024 * 1024);

      _logger.d('=== INFORMACIÓN DEL ARCHIVO: $description ===');
      _logger.d('Ruta: ${file.path}');
      _logger.d('Existe: ${await file.exists()}');
      _logger.d(
        'Tamaño: $fileSize bytes (${fileSizeInMB.toStringAsFixed(2)} MB)',
      );

      if (await file.exists()) {
        final lastModified = await file.lastModified();
        _logger.d('Última modificación: $lastModified');
      }

      _logger.d('==================================');
    } catch (e) {
      _logger.e('Error al obtener información del archivo $description: $e');
    }
  }

  /// Verifica si un archivo es válido para el análisis
  static Future<bool> isValidImageFile(File file) async {
    try {
      if (!await file.exists()) {
        _logger.w('El archivo no existe: ${file.path}');
        return false;
      }

      final fileSize = await file.length();
      const maxSize = 10 * 1024 * 1024; // 10MB
      const minSize = 1024; // 1KB

      if (fileSize > maxSize) {
        _logger.w('Archivo demasiado grande: ${fileSize / (1024 * 1024)} MB');
        return false;
      }

      if (fileSize < minSize) {
        _logger.w('Archivo demasiado pequeño: $fileSize bytes');
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
      _logger.e('Error al validar archivo: $e');
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
    print('🧪 [API_DEBUG] === TESTING FAVORITES API ===');

    try {
      final dioClient = sl<DioClient>();
      final tokenStorage = sl<TokenStorage>();

      final token = await tokenStorage.getToken();
      print('🔑 [API_DEBUG] Token disponible: ${token != null}');

      if (token != null) {
        print('🔑 [API_DEBUG] Token preview: ${token.substring(0, 20)}...');
      }

      print('🌐 [API_DEBUG] Base URL: ${dioClient.dio.options.baseUrl}');
      print('🚀 [API_DEBUG] Haciendo petición GET /favorites...');

      final response = await dioClient.dio.get(
        '/favorites',
        options: Options(
          headers: {if (token != null) 'Authorization': 'Bearer $token'},
        ),
      );

      print('✅ [API_DEBUG] Status Code: ${response.statusCode}');
      print('📄 [API_DEBUG] Response Headers: ${response.headers}');
      print('📋 [API_DEBUG] Response Data: ${response.data}');

      if (response.data != null && response.data['data'] != null) {
        final favorites = response.data['data']['favorites'] as List?;
        print('📊 [API_DEBUG] Número de favoritos: ${favorites?.length ?? 0}');

        if (favorites != null && favorites.isNotEmpty) {
          for (int i = 0; i < favorites.length; i++) {
            final fav = favorites[i];
            print('  📋 Favorito $i:');
            print('    - ID: ${fav['id']}');
            print('    - Business ID: ${fav['businessId']}');
            print('    - Business Name: ${fav['business']?['name'] ?? 'N/A'}');
          }
        }
      }
    } catch (e, stackTrace) {
      print('❌ [API_DEBUG] Error: $e');
      print('🔍 [API_DEBUG] Stack trace: $stackTrace');
    }

    print('🧪 [API_DEBUG] === END TEST ===');
  }

  static Future<void> testFavoritesFullFlow() async {
    print('🧪 [API_DEBUG] === TESTING FULL FAVORITES FLOW ===');

    try {
      // 1. Test directo de la API
      await testFavoritesApi();

      // 2. Test del use case completo
      print('\n🧪 [API_DEBUG] === TESTING USE CASE ===');
      final getFavoritesUseCase = sl<GetFavorites>();
      final response = await getFavoritesUseCase.execute();

      print('📊 [API_DEBUG] Use case response success: ${response.success}');
      print('📊 [API_DEBUG] Use case response message: ${response.message}');
      print(
        '📊 [API_DEBUG] Use case favorites count: ${response.data.favorites.length}',
      );

      // 3. Inspeccionar cada favorito del use case
      for (int i = 0; i < response.data.favorites.length; i++) {
        final fav = response.data.favorites[i];
        print('  📋 Use case favorito $i:');
        print('    - ID: ${fav.id}');
        print('    - Business ID: ${fav.businessId}');
        print('    - Business Name: ${fav.business.name}');
        print('    - Runtime Type: ${fav.runtimeType}');
      }
    } catch (e, stackTrace) {
      print('❌ [API_DEBUG] Error en full flow: $e');
      print('🔍 [API_DEBUG] Stack trace: $stackTrace');
    }

    print('🧪 [API_DEBUG] === END FULL FLOW TEST ===');
  }

  static Future<void> testAddFavorite(String businessId) async {
    print('🧪 [API_DEBUG] === TESTING ADD FAVORITE ===');
    print('🧪 [API_DEBUG] Business ID to add: $businessId');

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

      print('✅ [API_DEBUG] Add Favorite Status: ${response.statusCode}');
      print('📄 [API_DEBUG] Add Favorite Response: ${response.data}');

      // Después de agregar, obtener la lista actualizada
      print('\n🔄 [API_DEBUG] Obteniendo lista actualizada...');
      await testFavoritesApi();
    } catch (e, stackTrace) {
      print('❌ [API_DEBUG] Error agregando favorito: $e');
      print('🔍 [API_DEBUG] Stack trace: $stackTrace');
    }

    print('🧪 [API_DEBUG] === END ADD FAVORITE TEST ===');
  }
}

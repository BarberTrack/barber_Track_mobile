import 'package:logger/logger.dart';
import 'dart:io';

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
}

import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ImageCompressionService {
  /// Comprime una imagen para optimizar el envío al servidor
  static Future<File> compressImageForAnalysis(File imageFile) async {
    try {
      // Obtener directorio temporal
      final Directory tempDir = await getTemporaryDirectory();
      final String fileName =
          'compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String targetPath = path.join(tempDir.path, fileName);

      // Comprimir imagen
      final XFile? compressedFile =
          await FlutterImageCompress.compressAndGetFile(
            imageFile.absolute.path,
            targetPath,
            quality: 80, // Calidad buena pero comprimida
            minWidth: 800, // Ancho mínimo
            minHeight: 600, // Alto mínimo
            format: CompressFormat.jpeg,
          );

      if (compressedFile != null) {
        return File(compressedFile.path);
      } else {
        // Si la compresión falla, devolver archivo original
        return imageFile;
      }
    } catch (e) {
      // En caso de error, devolver archivo original
      return imageFile;
    }
  }

  /// Comprime una imagen para vista previa (más pequeña)
  static Future<File> compressImageForPreview(File imageFile) async {
    try {
      final Directory tempDir = await getTemporaryDirectory();
      final String fileName =
          'preview_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String targetPath = path.join(tempDir.path, fileName);

      final XFile? compressedFile =
          await FlutterImageCompress.compressAndGetFile(
            imageFile.absolute.path,
            targetPath,
            quality: 70,
            minWidth: 200,
            minHeight: 150,
            format: CompressFormat.jpeg,
          );

      if (compressedFile != null) {
        return File(compressedFile.path);
      } else {
        return imageFile;
      }
    } catch (e) {
      return imageFile;
    }
  }

  /// Obtiene el tamaño de un archivo en MB
  static double getFileSizeInMB(File file) {
    int sizeInBytes = file.lengthSync();
    return sizeInBytes / (1024 * 1024);
  }

  /// Verifica si un archivo necesita compresión
  static bool needsCompression(File file) {
    double sizeInMB = getFileSizeInMB(file);
    return sizeInMB > 2.0; // Comprimir si es mayor a 2MB
  }
}

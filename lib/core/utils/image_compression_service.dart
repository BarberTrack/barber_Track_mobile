import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ImageCompressionService {
  static Future<File> compressImageForAnalysis(File imageFile) async {
    try {
      final Directory tempDir = await getTemporaryDirectory();
      final String fileName =
          'compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String targetPath = path.join(tempDir.path, fileName);

      final XFile? compressedFile =
          await FlutterImageCompress.compressAndGetFile(
            imageFile.absolute.path,
            targetPath,
            quality: 80, 
            minWidth: 800, 
            minHeight: 600, 
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

  static double getFileSizeInMB(File file) {
    int sizeInBytes = file.lengthSync();
    return sizeInBytes / (1024 * 1024);
  }

  static bool needsCompression(File file) {
    double sizeInMB = getFileSizeInMB(file);
    return sizeInMB > 2.0; 
  }
}

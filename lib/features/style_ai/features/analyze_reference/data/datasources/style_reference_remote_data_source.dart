import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import '../../../../../../core/network/dio_client.dart';
import '../../../../../../core/storage/token_storage.dart';
import '../../../../../../core/utils/image_compression_service.dart';
import '../models/style_analysis_response_model.dart';

abstract class StyleReferenceRemoteDataSource {
  Future<StyleAnalysisResponseModel> analyzeReferenceImage(File referenceImage);
}

class StyleReferenceRemoteDataSourceImpl
    implements StyleReferenceRemoteDataSource {
  final DioClient dioClient;
  final TokenStorage tokenStorage;

  StyleReferenceRemoteDataSourceImpl(this.dioClient, this.tokenStorage);

  /// Detecta el tipo MIME correcto basado en la extensión del archivo
  MediaType _getMediaType(String filePath) {
    final extension = filePath.toLowerCase();
    if (extension.endsWith('.jpg') || extension.endsWith('.jpeg')) {
      return MediaType('image', 'jpeg');
    } else if (extension.endsWith('.png')) {
      return MediaType('image', 'png');
    } else if (extension.endsWith('.webp')) {
      return MediaType('image', 'webp');
    }
    // Default a JPEG si no se puede determinar
    return MediaType('image', 'jpeg');
  }

  @override
  Future<StyleAnalysisResponseModel> analyzeReferenceImage(
    File referenceImage,
  ) async {
    try {
      // Comprimir imagen antes del envío para optimizar el tamaño
      final File compressedImage =
          await ImageCompressionService.compressImageForAnalysis(
            referenceImage,
          );

      // Obtener el token de autenticación
      final token = await tokenStorage.getToken();
      if (token == null) {
        throw Exception('Token de autenticación no encontrado');
      }

      // Crear FormData para multipart/form-data con contentType correcto
      final formData = FormData.fromMap({
        'referencePhoto': await MultipartFile.fromFile(
          compressedImage.path,
          filename: 'reference_image.jpg',
          contentType: _getMediaType(compressedImage.path),
        ),
      });

      // Configurar headers y timeouts para esta petición específica
      final options = Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': '*/*',
          'Content-Type': 'multipart/form-data',
        },
        receiveTimeout: const Duration(
          minutes: 2,
        ), // Timeout más largo para procesamiento de IA
        sendTimeout: const Duration(minutes: 2),
      );

   

      // Realizar la petición POST - endpoint correcto que coincide con el curl funcionando
      final response = await dioClient.dio.post(
        '/api/style/generate-description',
        data: formData,
        options: options,
      );



      if (response.statusCode == 200 || response.statusCode == 201) {
        return StyleAnalysisResponseModel.fromJson(response.data);
      } else {
        throw Exception('Error en la petición: ${response.statusCode}');
      }
    } on DioException catch (e) {


      if (e.response?.statusCode == 401) {
        throw Exception('Token de autenticación inválido o expirado');
      } else if (e.response?.statusCode == 413) {
        throw Exception(
          'La imagen es demasiado grande. Usa una imagen más pequeña.',
        );
      } else if (e.response?.statusCode == 429) {
        throw Exception('Límite de solicitudes alcanzado. Intenta más tarde.');
      } else if (e.response?.statusCode == 400) {
        throw Exception('Imagen inválida o formato no soportado');
      } else if (e.response?.statusCode == 500) {
        String serverMessage = 'Error interno del servidor';

        try {
          final responseData = e.response?.data;
          if (responseData is Map<String, dynamic>) {
            final errorDetails = responseData['error']?['details'];
            if (errorDetails != null &&
                errorDetails['originalMessage'] != null) {
              serverMessage =
                  'Error del servidor: ${errorDetails['originalMessage']}';
            } else if (responseData['error']?['message'] != null) {
              serverMessage =
                  'Error del servidor: ${responseData['error']['message']}';
            } else if (responseData['message'] != null) {
              serverMessage = 'Error del servidor: ${responseData['message']}';
            }
          }
        } catch (_) {
          // Si no se puede parsear, usar mensaje por defecto
        }

        throw Exception(serverMessage);
      } else if (e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw Exception(
          'El análisis está tardando más de lo esperado. Verifica tu conexión e inténtalo nuevamente.',
        );
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception(
          'No se pudo conectar al servidor. Verifica tu conexión a internet.',
        );
      } else {
        throw Exception(
          'Error de conexión: ${e.message ?? 'Error desconocido'}',
        );
      }
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }
}

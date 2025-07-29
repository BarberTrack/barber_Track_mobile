import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import '../../../../../../core/network/dio_client.dart';
import '../../../../../../core/storage/token_storage.dart';
import '../models/face_analysis_model.dart';
import 'package:logger/logger.dart';

abstract class FaceAnalysisRemoteDataSource {
  Future<FaceAnalysisModel> analyzeFace({
    required File frontPhoto,
    required File profilePhoto,
  });

  Future<bool> testConnectivity();
}

class FaceAnalysisRemoteDataSourceImpl implements FaceAnalysisRemoteDataSource {
  final DioClient dioClient;
  final TokenStorage tokenStorage;
  final Logger logger = Logger();
  FaceAnalysisRemoteDataSourceImpl(this.dioClient, this.tokenStorage);

 
  MediaType _getMediaType(String filePath) {
    final extension = filePath.toLowerCase();
    if (extension.endsWith('.jpg') || extension.endsWith('.jpeg')) {
      return MediaType('image', 'jpeg');
    } else if (extension.endsWith('.png')) {
      return MediaType('image', 'png');
    } else if (extension.endsWith('.webp')) {
      return MediaType('image', 'webp');
    }
    
    return MediaType('image', 'jpeg');
  }

  @override
  Future<FaceAnalysisModel> analyzeFace({
    required File frontPhoto,
    required File profilePhoto,
  }) async {
    try {
      final token = await tokenStorage.getToken();

      
      final formData = FormData.fromMap({
        'photos': [
          await MultipartFile.fromFile(
            frontPhoto.path,
            filename: 'front_photo.jpeg',
            contentType: _getMediaType(
              frontPhoto.path,
            ), 
          ),
          await MultipartFile.fromFile(
            profilePhoto.path,
            filename: 'profile_photo.jpeg',
            contentType: _getMediaType(
              profilePhoto.path,
            ), 
          ),
        ],
      });

      // logger.d('Enviando análisis facial...');
      // logger.d('Tamaño foto frontal: ${await frontPhoto.length()} bytes');
      // logger.d('Tamaño foto perfil: ${await profilePhoto.length()} bytes');
      // logger.d('Tipo MIME foto frontal: ${_getMediaType(frontPhoto.path)}');
      // logger.d('Tipo MIME foto perfil: ${_getMediaType(profilePhoto.path)}');

      final response = await dioClient.dio.post(
        '/api/style/analyze-face',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
          receiveTimeout: const Duration(
            minutes: 2,
          ), 
          sendTimeout: const Duration(minutes: 2),
        ),
      );
      // logger.d('Respuesta recibida - Status: ${response.statusCode}');
      // logger.d('Respuesta data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;

        
        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('data')) {
          final data = responseData['data'] as Map<String, dynamic>;
          return FaceAnalysisModel.fromJson(data);
        } else {
          
          // logger.e('Estructura de respuesta inesperada: $responseData');
          throw Exception(
            'La respuesta del servidor no tiene el formato esperado',
          );
        }
      } else {
        logger.e('Error HTTP ${response.statusCode}: ${response.data}');
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message:
              'Error al analizar el rostro - Código: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      logger.e('DioException: ${e.message}');
      logger.e('Status Code: ${e.response?.statusCode}');
      logger.e('Response Data: ${e.response?.data}');

      if (e.response?.statusCode == 401) {
        throw Exception(
          'Token de autorización inválido. Inicia sesión nuevamente.',
        );
      } else if (e.response?.statusCode == 413) {
        throw Exception(
          'Las imágenes son demasiado grandes. Usa imágenes más pequeñas.',
        );
      } else if (e.response?.statusCode == 429) {
        throw Exception(
          'Has excedido el límite diario de análisis. Inténtalo mañana.',
        );
      } else if (e.response?.statusCode == 500) {
        
        String serverMessage =
            'El servidor está experimentando problemas. Inténtalo más tarde.';

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
            }
          }
        } catch (_) {
          
        }

        throw Exception(serverMessage);
      } else if (e.response?.statusCode == 400) {
        final errorMsg =
            e.response?.data?['message'] ?? 'Datos de la petición inválidos';
        throw Exception('Error en la petición: $errorMsg');
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
      logger.e('Error inesperado: $e');
      throw Exception('Error inesperado al procesar el análisis: $e');
    }
  }

  @override
  Future<bool> testConnectivity() async {
    try {
      final token = await tokenStorage.getToken();


      if (token == null || token.isEmpty) {
        logger.e('No hay token disponible');
        return false;
      }

       
      return true;
    } catch (e) {
      logger.e('Error en test de conectividad: $e');
      return false;
    }
  }
}

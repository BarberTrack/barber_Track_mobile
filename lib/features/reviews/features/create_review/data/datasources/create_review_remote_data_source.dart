import 'package:dio/dio.dart';
import '../../../../../../core/network/dio_client.dart';
import '../../../../../../core/storage/token_storage.dart';
import '../models/create_review_request_model.dart';
import '../models/create_review_response_model.dart';

abstract class CreateReviewRemoteDataSource {
  Future<CreateReviewResponseModel> createReview(
    CreateReviewRequestModel request,
  );
}

class CreateReviewRemoteDataSourceImpl implements CreateReviewRemoteDataSource {
  final DioClient dioClient;
  final TokenStorage tokenStorage;

  CreateReviewRemoteDataSourceImpl(this.dioClient, this.tokenStorage);

  @override
  Future<CreateReviewResponseModel> createReview(
    CreateReviewRequestModel request,
  ) async {
    try {
      final token = await tokenStorage.getToken();

      final response = await dioClient.dio.post(
        '/reviews',
        data: request.toJson(),
        options: Options(
          headers: {if (token != null) 'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return CreateReviewResponseModel.fromJson(response.data);
      } else {
        throw Exception('Error al crear la reseña: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception('Ya hay una reseña para esta cita');
      } else if (e.response?.statusCode == 500) {
        throw Exception('Ya hay una reseña para esta cita');
      } else {
        throw Exception('Error de conexión: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }
}

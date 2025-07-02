import 'package:dio/dio.dart';
import '../../../../../../core/network/dio_client.dart';
import '../../../../../../core/storage/token_storage.dart';
import '../models/business_review_response_model.dart';

abstract class BusinessReviewRemoteDataSource {
  Future<BusinessReviewResponseModel> getBusinessReviews(
    String businessId, {
    String? status,
  });
}

class BusinessReviewRemoteDataSourceImpl
    implements BusinessReviewRemoteDataSource {
  final DioClient dioClient;
  final TokenStorage tokenStorage;

  BusinessReviewRemoteDataSourceImpl(this.dioClient, this.tokenStorage);

  @override
  Future<BusinessReviewResponseModel> getBusinessReviews(
    String businessId, {
    String? status,
  }) async {
    try {
      final token = await tokenStorage.getToken();

      final queryParams = {'businessId': businessId};
      if (status != null) {
        queryParams['status'] = status;
      }

      final response = await dioClient.dio.get(
        '/reviews',
        queryParameters: queryParams,
        options: Options(
          headers: {if (token != null) 'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        return BusinessReviewResponseModel.fromJson(response.data);
      } else {
        throw Exception('Error al obtener las reseñas: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Error del servidor: ${e.response?.statusMessage}');
      } else {
        throw Exception('Error de conexión: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }
}

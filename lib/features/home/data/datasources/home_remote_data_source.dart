import 'package:dio/dio.dart';
import '../models/business_model.dart';
import '../../../../core/network/dio_client.dart';

abstract class HomeRemoteDataSource {
  Future<List<BusinessModel>> getBusinesses();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final DioClient dioClient;
  late final Dio _businessDio;

  HomeRemoteDataSourceImpl(this.dioClient) {
    _businessDio = Dio(
      BaseOptions(
        baseUrl: 'https://api-barber-dummie-production.up.railway.app',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );


  }

  @override
  Future<List<BusinessModel>> getBusinesses() async {
    try {
      final response = await _businessDio.get('/businesses');

      if (response.statusCode == 200) {
        final data = response.data;
        final businessesData = data['businesses'] as List<dynamic>;

        return businessesData
            .map((businessJson) => BusinessModel.fromJson(businessJson))
            .toList();
      } else {
        throw Exception('Failed to load businesses: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}

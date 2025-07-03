import 'package:dio/dio.dart';
import '../../../../../../core/network/dio_client.dart';
import '../../../../../../core/storage/token_storage.dart';
import '../models/barber_model.dart';

abstract class BarberRemoteDataSource {
  Future<List<BarberModel>> getBarbersByBusinessId(String businessId);
}

class BarberRemoteDataSourceImpl implements BarberRemoteDataSource {
  final DioClient dioClient;
  final TokenStorage tokenStorage;

  BarberRemoteDataSourceImpl(this.dioClient, this.tokenStorage);

  @override
  Future<List<BarberModel>> getBarbersByBusinessId(String businessId) async {
    try {
      final token = await tokenStorage.getToken();

      final response = await dioClient.dio.get(
        '/barbers/business/$businessId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          final List<dynamic> barbersJson = data['data'];
          return barbersJson.map((json) => BarberModel.fromJson(json)).toList();
        } else {
          throw Exception('Response indicates failure: ${data['message']}');
        }
      } else {
        throw Exception(
          'Failed to load barbers. Status code: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          'API Error: ${e.response?.data['message'] ?? e.message}',
        );
      } else {
        throw Exception('Network Error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}

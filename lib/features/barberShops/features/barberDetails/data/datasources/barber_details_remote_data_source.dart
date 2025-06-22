import '../../../../../../core/network/barber_dio_client.dart';
import '../models/barber_business_model.dart';

abstract class BarberDetailsRemoteDataSource {
  Future<BarberBusinessModel> getBusinessById(String businessId);
}

class BarberDetailsRemoteDataSourceImpl
    implements BarberDetailsRemoteDataSource {
  final BarberDioClient _client;

  BarberDetailsRemoteDataSourceImpl(this._client);

  @override
  Future<BarberBusinessModel> getBusinessById(String businessId) async {
    try {
      final response = await _client.dio.get('/businesses/$businessId');

      if (response.statusCode == 200) {
        return BarberBusinessModel.fromJson(response.data);
      } else {
        throw Exception(
          'Error al obtener detalles del negocio: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de red al obtener detalles del negocio: $e');
    }
  }
}

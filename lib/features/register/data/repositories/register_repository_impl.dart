import '../../domain/entities/register_request.dart';
import '../../domain/entities/register_response.dart';
import '../../domain/repositories/register_repository.dart';
import '../datasources/register_remote_data_source.dart';
import '../mappers/user_mapper.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  final RegisterRemoteDataSource remoteDataSource;

  RegisterRepositoryImpl(this.remoteDataSource);

  @override
  Future<RegisterResponse> registerUser(RegisterRequest request) async {
    final requestModel = UserMapper.toModel(request);
    final responseModel = await remoteDataSource.registerUser(requestModel);
    return UserMapper.toRegisterResponseEntity(responseModel);
  }
}

import 'package:get_it/get_it.dart';
import '../network/dio_client.dart';
import '../../features/login/data/datasources/login_remote_data_source.dart';
import '../../features/login/data/repositories/login_repository_impl.dart';
import '../../features/login/domain/repositories/login_repository.dart';
import '../../features/login/domain/usecases/authenticate_user.dart';
import '../../features/login/presentation/bloc/login_bloc.dart';

final GetIt sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Core
  sl.registerLazySingleton<DioClient>(() => DioClient());

  // Data sources
  sl.registerLazySingleton<LoginRemoteDataSource>(
    () => LoginRemoteDataSourceImpl(sl<DioClient>()),
  );

  // Repositories
  sl.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImpl(sl<LoginRemoteDataSource>()),
  );

  // Use cases
  sl.registerLazySingleton<AuthenticateUser>(
    () => AuthenticateUser(sl<LoginRepository>()),
  );

  // BLoCs
  sl.registerFactory<LoginBloc>(() => LoginBloc(sl<AuthenticateUser>()));
}

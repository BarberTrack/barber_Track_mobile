import 'package:get_it/get_it.dart';
import '../network/dio_client.dart';
import '../../features/login/data/datasources/login_remote_data_source.dart';
import '../../features/login/data/repositories/login_repository_impl.dart';
import '../../features/login/domain/repositories/login_repository.dart';
import '../../features/login/domain/usecases/authenticate_user.dart';
import '../../features/login/presentation/bloc/login_bloc.dart';

// Home feature imports
import '../../features/home/data/datasources/home_remote_data_source.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/domain/usecases/get_businesses.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';

final GetIt sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Core
  sl.registerLazySingleton<DioClient>(() => DioClient());

  // Login feature - Data sources
  sl.registerLazySingleton<LoginRemoteDataSource>(
    () => LoginRemoteDataSourceImpl(sl<DioClient>()),
  );

  // Login feature - Repositories
  sl.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImpl(sl<LoginRemoteDataSource>()),
  );

  // Login feature - Use cases
  sl.registerLazySingleton<AuthenticateUser>(
    () => AuthenticateUser(sl<LoginRepository>()),
  );

  // Login feature - BLoCs
  sl.registerFactory<LoginBloc>(() => LoginBloc(sl<AuthenticateUser>()));

  // Home feature - Data sources
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(sl<DioClient>()),
  );

  // Home feature - Repositories
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(sl<HomeRemoteDataSource>()),
  );

  // Home feature - Use cases
  sl.registerLazySingleton<GetBusinesses>(
    () => GetBusinesses(sl<HomeRepository>()),
  );

  // Home feature - BLoCs
  sl.registerFactory<HomeBloc>(() => HomeBloc(sl<GetBusinesses>()));
}

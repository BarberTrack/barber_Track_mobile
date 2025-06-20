import 'package:get_it/get_it.dart';
import '../network/dio_client.dart';
import '../storage/token_storage.dart';
import '../../features/login/data/datasources/login_remote_data_source.dart';
import '../../features/login/data/repositories/login_repository_impl.dart';
import '../../features/login/domain/repositories/login_repository.dart';
import '../../features/login/domain/usecases/authenticate_user.dart';
import '../../features/login/presentation/bloc/login_bloc.dart';


import '../../features/home/data/datasources/home_remote_data_source.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/domain/usecases/get_businesses.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';

final GetIt sl = GetIt.instance;

Future<void> initializeDependencies() async {

  sl.registerLazySingleton<DioClient>(() => DioClient());
  sl.registerLazySingleton<TokenStorage>(() => TokenStorage());

 
  sl.registerLazySingleton<LoginRemoteDataSource>(
    () => LoginRemoteDataSourceImpl(sl<DioClient>(), sl<TokenStorage>()),
  );

  
  sl.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImpl(sl<LoginRemoteDataSource>()),
  );

  
  sl.registerLazySingleton<AuthenticateUser>(
    () => AuthenticateUser(sl<LoginRepository>()),
  );

 
  sl.registerFactory<LoginBloc>(() => LoginBloc(sl<AuthenticateUser>()));

  
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(sl<DioClient>()),
  );

 
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(sl<HomeRemoteDataSource>()),
  );

  
  sl.registerLazySingleton<GetBusinesses>(
    () => GetBusinesses(sl<HomeRepository>()),
  );

  
  sl.registerFactory<HomeBloc>(() => HomeBloc(sl<GetBusinesses>()));
}

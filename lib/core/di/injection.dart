import 'package:get_it/get_it.dart';
import '../network/dio_client.dart';
import '../network/barber_dio_client.dart';
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

// BarberDetails imports
import '../../features/barberShops/features/barberDetails/data/datasources/barber_details_remote_data_source.dart';
import '../../features/barberShops/features/barberDetails/data/repositories/barber_details_repository_impl.dart';
import '../../features/barberShops/features/barberDetails/domain/repositories/barber_details_repository.dart';
import '../../features/barberShops/features/barberDetails/domain/usecases/get_business_by_id.dart';
import '../../features/barberShops/features/barberDetails/presentation/bloc/barberdetails_bloc.dart';

final GetIt sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Core dependencies
  sl.registerLazySingleton<DioClient>(() => DioClient());
  sl.registerLazySingleton<BarberDioClient>(() => BarberDioClient());
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

  // BarberDetails dependencies
  sl.registerLazySingleton<BarberDetailsRemoteDataSource>(
    () => BarberDetailsRemoteDataSourceImpl(sl<BarberDioClient>()),
  );

  sl.registerLazySingleton<BarberDetailsRepository>(
    () => BarberDetailsRepositoryImpl(sl<BarberDetailsRemoteDataSource>()),
  );

  sl.registerLazySingleton<GetBusinessById>(
    () => GetBusinessById(sl<BarberDetailsRepository>()),
  );

  sl.registerFactory<BarberdetailsBloc>(
    () => BarberdetailsBloc(sl<GetBusinessById>()),
  );
}

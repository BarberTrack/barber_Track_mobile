import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import '../network/dio_client.dart';
import '../network/barber_dio_client.dart';
import '../storage/token_storage.dart';
import '../storage/favorites_storage.dart';
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

// CreateAppointment imports
import '../../features/appointments/features/create_appointment/data/datasources/appointment_remote_data_source.dart';
import '../../features/appointments/features/create_appointment/data/repositories/appointment_repository_impl.dart';
import '../../features/appointments/features/create_appointment/domain/repositories/appointment_repository.dart';
import '../../features/appointments/features/create_appointment/domain/usecases/get_business_services.dart';
import '../../features/appointments/features/create_appointment/domain/usecases/get_availability.dart';
import '../../features/appointments/features/create_appointment/domain/usecases/create_appointment.dart'
    as appointment_usecase;
import '../../features/appointments/features/create_appointment/presentation/bloc/create_appointment_bloc.dart';

// Appointments Home imports
import '../../features/appointments/features/appoinments_home/data/datasources/appointments_remote_data_source.dart';
import '../../features/appointments/features/appoinments_home/data/repositories/appointments_repository_impl.dart';
import '../../features/appointments/features/appoinments_home/domain/repositories/appointments_repository.dart';
import '../../features/appointments/features/appoinments_home/domain/usecases/get_appointments.dart';
import '../../features/appointments/features/appoinments_home/presentation/bloc/appointments_bloc.dart';

// Style AI imports
import '../../features/style_ai/features/style_ai_home/data/datasources/style_history_remote_data_source.dart';
import '../../features/style_ai/features/style_ai_home/data/repositories/style_history_repository_impl.dart';
import '../../features/style_ai/features/style_ai_home/domain/repositories/style_history_repository.dart';
import '../../features/style_ai/features/style_ai_home/domain/usecases/get_style_history.dart';
import '../../features/style_ai/features/style_ai_home/presentation/bloc/style_ai_home_bloc.dart';

// Analyze Face imports
import '../../features/style_ai/features/analyze_face/data/datasources/face_analysis_remote_data_source.dart';
import '../../features/style_ai/features/analyze_face/data/repositories/face_analysis_repository_impl.dart';
import '../../features/style_ai/features/analyze_face/domain/repositories/face_analysis_repository.dart';
import '../../features/style_ai/features/analyze_face/domain/usecases/analyze_face.dart';
import '../../features/style_ai/features/analyze_face/presentation/bloc/analyze_face_bloc.dart';

// Analyze Reference imports
import '../../features/style_ai/features/analyze_reference/data/datasources/style_reference_remote_data_source.dart';
import '../../features/style_ai/features/analyze_reference/data/repositories/style_reference_repository_impl.dart';
import '../../features/style_ai/features/analyze_reference/domain/repositories/style_reference_repository.dart';
import '../../features/style_ai/features/analyze_reference/domain/usecases/analyze_reference_image.dart';
import '../../features/style_ai/features/analyze_reference/presentation/bloc/analyze_reference_bloc.dart';

// Business Review imports
import '../../features/reviews/features/business_review/data/datasources/business_review_remote_data_source.dart';
import '../../features/reviews/features/business_review/data/repositories/business_review_repository_impl.dart';
import '../../features/reviews/features/business_review/domain/repositories/business_review_repository.dart';
import '../../features/reviews/features/business_review/domain/usecases/get_business_reviews.dart';
import '../../features/reviews/features/business_review/presentation/bloc/business_review_bloc.dart';

// Create Review imports
import '../../features/reviews/features/create_review/data/datasources/create_review_remote_data_source.dart';
import '../../features/reviews/features/create_review/data/repositories/create_review_repository_impl.dart';
import '../../features/reviews/features/create_review/domain/repositories/create_review_repository.dart';
import '../../features/reviews/features/create_review/domain/usecases/create_review.dart';
import '../../features/reviews/features/create_review/presentation/bloc/create_review_bloc.dart';

// Favorites imports
import '../../features/favorites/data/datasources/favorites_remote_data_source.dart';
import '../../features/favorites/data/repositories/favorites_repository_impl.dart';
import '../../features/favorites/domain/repositories/favorites_repository.dart';
import '../../features/favorites/domain/usecases/get_favorites.dart';
import '../../features/favorites/domain/usecases/add_to_favorites.dart';
import '../../features/favorites/domain/usecases/remove_from_favorites.dart';
import '../../features/favorites/presentation/bloc/favorites_bloc.dart';

// Barber Home imports
import '../../features/barbers/features/barber_home/data/datasources/barber_remote_data_source.dart';
import '../../features/barbers/features/barber_home/data/repositories/barber_repository_impl.dart';
import '../../features/barbers/features/barber_home/domain/repositories/barber_repository.dart';
import '../../features/barbers/features/barber_home/domain/usecases/get_barbers.dart';
import '../../features/barbers/features/barber_home/presentation/bloc/barber_home_bloc.dart';

// Notification imports
import '../services/notification_service.dart';

// Cancel Appointment imports
import '../../features/appointments/features/cancel_appointment/data/datasources/cancel_appointment_remote_data_source.dart';
import '../../features/appointments/features/cancel_appointment/data/repositories/cancel_appointment_repository_impl.dart';
import '../../features/appointments/features/cancel_appointment/domain/repositories/cancel_appointment_repository.dart';
import '../../features/appointments/features/cancel_appointment/domain/usecases/cancel_appointment.dart';
import '../../features/appointments/features/cancel_appointment/presentation/bloc/cancel_appointment_bloc.dart';

// Business Services imports
import '../../features/barberShops/features/business_services/data/datasources/business_services_remote_data_source.dart';
import '../../features/barberShops/features/business_services/data/repositories/business_services_repository_impl.dart';
import '../../features/barberShops/features/business_services/domain/repositories/business_services_repository.dart';
import '../../features/barberShops/features/business_services/domain/usecases/get_business_services.dart'
    as business_services_usecase;
import '../../features/barberShops/features/business_services/presentation/bloc/business_services_bloc.dart';

// Map imports
import '../../features/map/data/datasources/map_remote_data_source.dart';
import '../../features/map/data/repositories/map_repository_impl.dart';
import '../../features/map/domain/repositories/map_repository.dart';
import '../../features/map/domain/usecases/get_map_businesses.dart';
import '../../features/map/presentation/bloc/map_bloc.dart';

final GetIt sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Inicializar firebase
  await NotificationService.initialize();

  // Core dependencies
  sl.registerLazySingleton<DioClient>(() => DioClient());
  sl.registerLazySingleton<BarberDioClient>(() => BarberDioClient());
  sl.registerLazySingleton<TokenStorage>(() => TokenStorage());
  sl.registerLazySingleton<FavoritesStorage>(() => FavoritesStorage());
  sl.registerLazySingleton<Logger>(() => Logger());

  // Login dependencies
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

  // Home dependencies
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(sl<DioClient>(), sl<TokenStorage>()),
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
    () =>
        BarberDetailsRemoteDataSourceImpl(sl<DioClient>(), sl<TokenStorage>()),
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

  // CreateAppointment dependencies
  sl.registerLazySingleton<AppointmentRemoteDataSource>(
    () => AppointmentRemoteDataSourceImpl(sl<DioClient>(), sl<TokenStorage>()),
  );

  sl.registerLazySingleton<AppointmentRepository>(
    () => AppointmentRepositoryImpl(sl<AppointmentRemoteDataSource>()),
  );

  sl.registerLazySingleton<GetBusinessServices>(
    () => GetBusinessServices(sl<AppointmentRepository>()),
  );

  sl.registerLazySingleton<GetAvailability>(
    () => GetAvailability(sl<AppointmentRepository>()),
  );

  sl.registerLazySingleton<appointment_usecase.CreateAppointment>(
    () => appointment_usecase.CreateAppointment(sl<AppointmentRepository>()),
  );

  sl.registerFactory<CreateAppointmentBloc>(
    () => CreateAppointmentBloc(
      getBusinessServices: sl<GetBusinessServices>(),
      getAvailability: sl<GetAvailability>(),
      createAppointmentUseCase: sl<appointment_usecase.CreateAppointment>(),
    ),
  );

  // Appointments Home dependencies
  sl.registerLazySingleton<AppointmentsRemoteDataSource>(
    () => AppointmentsRemoteDataSourceImpl(sl<DioClient>(), sl<TokenStorage>()),
  );

  sl.registerLazySingleton<AppointmentsRepository>(
    () => AppointmentsRepositoryImpl(sl<AppointmentsRemoteDataSource>()),
  );

  sl.registerLazySingleton<GetAppointments>(
    () => GetAppointments(sl<AppointmentsRepository>()),
  );

  sl.registerFactory<AppointmentsBloc>(
    () => AppointmentsBloc(getAppointments: sl<GetAppointments>()),
  );

  // Style AI dependencies
  sl.registerLazySingleton<StyleHistoryRemoteDataSource>(
    () => StyleHistoryRemoteDataSourceImpl(sl<DioClient>(), sl<TokenStorage>()),
  );

  sl.registerLazySingleton<StyleHistoryRepository>(
    () => StyleHistoryRepositoryImpl(sl<StyleHistoryRemoteDataSource>()),
  );

  sl.registerLazySingleton<GetStyleHistory>(
    () => GetStyleHistory(sl<StyleHistoryRepository>()),
  );

  sl.registerFactory<StyleAiHomeBloc>(
    () => StyleAiHomeBloc(getStyleHistory: sl<GetStyleHistory>()),
  );

  // Analyze Face dependencies
  sl.registerLazySingleton<FaceAnalysisRemoteDataSource>(
    () => FaceAnalysisRemoteDataSourceImpl(sl<DioClient>(), sl<TokenStorage>()),
  );

  sl.registerLazySingleton<FaceAnalysisRepository>(
    () => FaceAnalysisRepositoryImpl(sl<FaceAnalysisRemoteDataSource>()),
  );

  sl.registerLazySingleton<AnalyzeFace>(
    () => AnalyzeFace(sl<FaceAnalysisRepository>()),
  );

  sl.registerFactory<AnalyzeFaceBloc>(
    () => AnalyzeFaceBloc(
      analyzeFaceUseCase: sl<AnalyzeFace>(),
      remoteDataSource: sl<FaceAnalysisRemoteDataSource>(),
    ),
  );

  // Analyze Reference dependencies
  sl.registerLazySingleton<StyleReferenceRemoteDataSource>(
    () =>
        StyleReferenceRemoteDataSourceImpl(sl<DioClient>(), sl<TokenStorage>()),
  );

  sl.registerLazySingleton<StyleReferenceRepository>(
    () => StyleReferenceRepositoryImpl(sl<StyleReferenceRemoteDataSource>()),
  );

  sl.registerLazySingleton<AnalyzeReferenceImage>(
    () => AnalyzeReferenceImage(sl<StyleReferenceRepository>()),
  );

  sl.registerFactory<AnalyzeReferenceBloc>(
    () => AnalyzeReferenceBloc(
      analyzeReferenceImageUseCase: sl<AnalyzeReferenceImage>(),
    ),
  );

  // Business Review dependencies
  sl.registerLazySingleton<BusinessReviewRemoteDataSource>(
    () =>
        BusinessReviewRemoteDataSourceImpl(sl<DioClient>(), sl<TokenStorage>()),
  );

  sl.registerLazySingleton<BusinessReviewRepository>(
    () => BusinessReviewRepositoryImpl(sl<BusinessReviewRemoteDataSource>()),
  );

  sl.registerLazySingleton<GetBusinessReviews>(
    () => GetBusinessReviews(sl<BusinessReviewRepository>()),
  );

  sl.registerFactory<BusinessReviewBloc>(
    () => BusinessReviewBloc(sl<GetBusinessReviews>()),
  );

  // Create Review dependencies
  sl.registerLazySingleton<CreateReviewRemoteDataSource>(
    () => CreateReviewRemoteDataSourceImpl(sl<DioClient>(), sl<TokenStorage>()),
  );

  sl.registerLazySingleton<CreateReviewRepository>(
    () => CreateReviewRepositoryImpl(sl<CreateReviewRemoteDataSource>()),
  );

  sl.registerLazySingleton<CreateReview>(
    () => CreateReview(sl<CreateReviewRepository>()),
  );

  sl.registerFactory<CreateReviewBloc>(
    () => CreateReviewBloc(createReviewUseCase: sl<CreateReview>()),
  );

  // Favorites dependencies
  sl.registerLazySingleton<FavoritesRemoteDataSource>(
    () => FavoritesRemoteDataSourceImpl(sl<DioClient>(), sl<TokenStorage>()),
  );

  sl.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(sl<FavoritesRemoteDataSource>()),
  );

  sl.registerLazySingleton<GetFavorites>(
    () => GetFavorites(sl<FavoritesRepository>()),
  );

  sl.registerLazySingleton<AddToFavorites>(
    () => AddToFavorites(sl<FavoritesRepository>()),
  );

  sl.registerLazySingleton<RemoveFromFavorites>(
    () => RemoveFromFavorites(sl<FavoritesRepository>()),
  );

  sl.registerFactory<FavoritesBloc>(
    () => FavoritesBloc(
      getFavoritesUseCase: sl<GetFavorites>(),
      addToFavoritesUseCase: sl<AddToFavorites>(),
      removeFromFavoritesUseCase: sl<RemoveFromFavorites>(),
      favoritesStorage: sl<FavoritesStorage>(),
    ),
  );

  // Barber Home dependencies
  sl.registerLazySingleton<BarberRemoteDataSource>(
    () => BarberRemoteDataSourceImpl(sl<DioClient>(), sl<TokenStorage>()),
  );

  sl.registerLazySingleton<BarberRepository>(
    () => BarberRepositoryImpl(sl<BarberRemoteDataSource>()),
  );

  sl.registerLazySingleton<GetBarbers>(
    () => GetBarbers(sl<BarberRepository>()),
  );

  sl.registerFactory<BarberHomeBloc>(
    () => BarberHomeBloc(getBarbers: sl<GetBarbers>()),
  );

  // Cancel Appointment dependencies
  sl.registerLazySingleton<CancelAppointmentRemoteDataSource>(
    () => CancelAppointmentRemoteDataSourceImpl(
      sl<DioClient>(),
      sl<TokenStorage>(),
      sl<Logger>(),
    ),
  );

  sl.registerLazySingleton<CancelAppointmentRepository>(
    () => CancelAppointmentRepositoryImpl(
      sl<CancelAppointmentRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<CancelAppointment>(
    () => CancelAppointment(sl<CancelAppointmentRepository>()),
  );

  sl.registerFactory<CancelAppointmentBloc>(
    () => CancelAppointmentBloc(
      cancelAppointmentUseCase: sl<CancelAppointment>(),
    ),
  );

  // Business Services dependencies
  sl.registerLazySingleton<BusinessServicesRemoteDataSource>(
    () => BusinessServicesRemoteDataSourceImpl(
      sl<DioClient>(),
      sl<TokenStorage>(),
    ),
  );

  sl.registerLazySingleton<BusinessServicesRepository>(
    () => BusinessServicesRepositoryImpl(
      remoteDataSource: sl<BusinessServicesRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<business_services_usecase.GetBusinessServices>(
    () => business_services_usecase.GetBusinessServices(
      sl<BusinessServicesRepository>(),
    ),
  );

  sl.registerFactory<BusinessServicesBloc>(
    () => BusinessServicesBloc(
      getBusinessServices: sl<business_services_usecase.GetBusinessServices>(),
    ),
  );

  // Map dependencies
  sl.registerLazySingleton<MapRemoteDataSource>(
    () => MapRemoteDataSourceImpl(sl<DioClient>(), sl<TokenStorage>()),
  );

  sl.registerLazySingleton<MapRepository>(
    () => MapRepositoryImpl(remoteDataSource: sl<MapRemoteDataSource>()),
  );

  sl.registerLazySingleton<GetMapBusinesses>(
    () => GetMapBusinesses(sl<MapRepository>()),
  );

  sl.registerFactory<MapBloc>(
    () => MapBloc(getMapBusinesses: sl<GetMapBusinesses>()),
  );
}

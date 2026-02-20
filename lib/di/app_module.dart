import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/logging/app_logger.dart';
import '../core/network/dio_client.dart';
import '../core/services/environment_config.dart';
import '../core/services/storage_service.dart';
import '../core/services/socket_service.dart';
import '../data/datasources/auth_remote_datasource.dart';
import '../data/datasources/booking_remote_datasource.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/booking_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/booking_repository.dart';
import '../domain/usecases/auth/login_usecase.dart';
import '../domain/usecases/auth/register_usecase.dart';
import '../domain/usecases/booking/create_booking_usecase.dart';
import '../domain/usecases/booking/get_bookings_usecase.dart';
import '../domain/usecases/booking/update_booking_status_usecase.dart';
import '../presentation/controllers/auth_controller.dart';
import '../presentation/controllers/booking_controller.dart';

/// Dependency injection module using GetIt
final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // Core Services
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // Logger
  getIt.registerSingleton<AppLogger>(DefaultAppLogger());

  // Storage Service
  getIt.registerSingleton<StorageService>(
    SharedPreferencesStorageService(
      getIt<SharedPreferences>(),
      getIt<AppLogger>(),
    ),
  );

  // Environment Config
  // In production, this would be set via build flavors or environment variables
  EnvironmentConfig.initialize(Environment.dev);

  // Network Client
  final token = await getIt<StorageService>().getToken();
  getIt.registerSingleton<DioClient>(
    DioClient(
      baseUrl: EnvironmentConfig.current.apiBaseUrl,
      logger: getIt<AppLogger>(),
      token: token,
    ),
  );

  // Socket Service
  getIt.registerSingleton<SocketService>(
    MockSocketService(getIt<AppLogger>()),
  );

  // Data Sources
  getIt.registerSingleton<AuthRemoteDataSource>(
    AuthRemoteDataSourceImpl(getIt<DioClient>()),
  );

  getIt.registerSingleton<BookingRemoteDataSource>(
    BookingRemoteDataSourceImpl(getIt<DioClient>()),
  );

  // Repositories
  getIt.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(
      getIt<AuthRemoteDataSource>(),
      getIt<StorageService>(),
    ),
  );

  getIt.registerSingleton<BookingRepository>(
    BookingRepositoryImpl(
      getIt<BookingRemoteDataSource>(),
    ),
  );

  // Use Cases
  getIt.registerSingleton<LoginUseCase>(
    LoginUseCase(getIt<AuthRepository>()),
  );

  getIt.registerSingleton<RegisterUseCase>(
    RegisterUseCase(getIt<AuthRepository>()),
  );

  getIt.registerSingleton<CreateBookingUseCase>(
    CreateBookingUseCase(getIt<BookingRepository>()),
  );

  getIt.registerSingleton<GetBookingsUseCase>(
    GetBookingsUseCase(getIt<BookingRepository>()),
  );

  getIt.registerSingleton<UpdateBookingStatusUseCase>(
    UpdateBookingStatusUseCase(getIt<BookingRepository>()),
  );

  // Controllers (GetX)
  getIt.registerLazySingleton<AuthController>(
    () => AuthController(
      getIt<LoginUseCase>(),
      getIt<RegisterUseCase>(),
    ),
  );

  getIt.registerLazySingleton<BookingController>(
    () => BookingController(
      getIt<CreateBookingUseCase>(),
      getIt<GetBookingsUseCase>(),
      getIt<UpdateBookingStatusUseCase>(),
      getIt<SocketService>(),
    ),
  );
}

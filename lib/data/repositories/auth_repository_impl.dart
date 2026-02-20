import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/auth_response.dart';
import '../../core/utils/result.dart';
import '../../core/services/storage_service.dart';
import '../datasources/auth_remote_datasource.dart';

/// Authentication repository implementation
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final StorageService _storageService;

  AuthRepositoryImpl(this._remoteDataSource, this._storageService);

  @override
  Future<Result<AuthResponse>> login(String email, String password) async {
    final result = await _remoteDataSource.login(email, password);
    
    return result.when(
      success: (authResponse) async {
        await _storageService.saveToken(authResponse.token);
        await _storageService.saveRefreshToken(authResponse.refreshToken);
        await _storageService.saveUserRole(authResponse.user.role);
        await _storageService.saveUserId(authResponse.user.id);
        return Success(authResponse);
      },
      failure: (message, error) => Failure(message, error),
    );
  }

  @override
  Future<Result<AuthResponse>> register({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    final result = await _remoteDataSource.register(
      email: email,
      password: password,
      name: name,
      role: role,
    );
    
    return result.when(
      success: (authResponse) async {
        await _storageService.saveToken(authResponse.token);
        await _storageService.saveRefreshToken(authResponse.refreshToken);
        await _storageService.saveUserRole(authResponse.user.role);
        await _storageService.saveUserId(authResponse.user.id);
        return Success(authResponse);
      },
      failure: (message, error) => Failure(message, error),
    );
  }

  @override
  Future<Result<void>> logout() async {
    await _storageService.clearAll();
    return const Success(null);
  }

  @override
  Future<Result<AuthResponse>> refreshToken(String refreshToken) async {
    final result = await _remoteDataSource.refreshToken(refreshToken);
    
    return result.when(
      success: (authResponse) async {
        await _storageService.saveToken(authResponse.token);
        await _storageService.saveRefreshToken(authResponse.refreshToken);
        return Success(authResponse);
      },
      failure: (message, error) => Failure(message, error),
    );
  }
}

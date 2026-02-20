import '../../core/network/dio_client.dart';
import '../../core/utils/result.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

/// Remote data source for authentication
abstract class AuthRemoteDataSource {
  Future<Result<AuthResponseModel>> login(String email, String password);
  Future<Result<AuthResponseModel>> register({
    required String email,
    required String password,
    required String name,
    required String role,
  });
  Future<Result<AuthResponseModel>> refreshToken(String refreshToken);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _client;

  AuthRemoteDataSourceImpl(this._client);

  @override
  Future<Result<AuthResponseModel>> login(String email, String password) async {
    final result = await _client.post<Map<String, dynamic>>(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
      },
      fromJson: (json) => json as Map<String, dynamic>,
    );

    return result.when(
      success: (data) => Success(AuthResponseModel.fromJson(data)),
      failure: (message, error) => Failure(message, error),
    );
  }

  @override
  Future<Result<AuthResponseModel>> register({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    final result = await _client.post<Map<String, dynamic>>(
      '/auth/register',
      data: {
        'email': email,
        'password': password,
        'name': name,
        'role': role,
      },
      fromJson: (json) => json as Map<String, dynamic>,
    );

    return result.when(
      success: (data) => Success(AuthResponseModel.fromJson(data)),
      failure: (message, error) => Failure(message, error),
    );
  }

  @override
  Future<Result<AuthResponseModel>> refreshToken(String refreshToken) async {
    final result = await _client.post<Map<String, dynamic>>(
      '/auth/refresh',
      data: {'refresh_token': refreshToken},
      fromJson: (json) => json as Map<String, dynamic>,
    );

    return result.when(
      success: (data) => Success(AuthResponseModel.fromJson(data)),
      failure: (message, error) => Failure(message, error),
    );
  }
}

import '../entities/auth_response.dart';
import '../../core/utils/result.dart';

/// Authentication repository interface
abstract class AuthRepository {
  Future<Result<AuthResponse>> login(String email, String password);
  Future<Result<AuthResponse>> register({
    required String email,
    required String password,
    required String name,
    required String role,
  });
  Future<Result<void>> logout();
  Future<Result<AuthResponse>> refreshToken(String refreshToken);
}

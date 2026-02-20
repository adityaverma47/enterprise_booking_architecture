import '../../repositories/auth_repository.dart';
import '../../entities/auth_response.dart';
import '../../../core/utils/result.dart';

/// Register use case
class RegisterUseCase {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  Future<Result<AuthResponse>> call({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      return const Failure('All fields are required');
    }

    if (!_isValidEmail(email)) {
      return const Failure('Invalid email format');
    }

    if (password.length < 6) {
      return const Failure('Password must be at least 6 characters');
    }

    if (!['user', 'provider', 'admin'].contains(role)) {
      return const Failure('Invalid role');
    }

    return await _repository.register(
      email: email,
      password: password,
      name: name,
      role: role,
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}

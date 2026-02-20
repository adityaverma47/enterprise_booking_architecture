import '../../repositories/auth_repository.dart';
import '../../entities/auth_response.dart';
import '../../../core/utils/result.dart';

/// Login use case - encapsulates business logic for authentication
class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<Result<AuthResponse>> call(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      return const Failure('Email and password are required');
    }

    if (!_isValidEmail(email)) {
      return const Failure('Invalid email format');
    }

    return await _repository.login(email, password);
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}

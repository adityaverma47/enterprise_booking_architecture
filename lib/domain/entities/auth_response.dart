import 'user.dart';

/// Authentication response entity
class AuthResponse {
  final String token;
  final String refreshToken;
  final User user;

  const AuthResponse({
    required this.token,
    required this.refreshToken,
    required this.user,
  });
}

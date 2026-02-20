import '../../domain/entities/auth_response.dart';
import 'user_model.dart';

/// Auth response data model
class AuthResponseModel extends AuthResponse {
  const AuthResponseModel({
    required super.token,
    required super.refreshToken,
    required super.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      token: json['token'] as String,
      refreshToken: json['refresh_token'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'refresh_token': refreshToken,
      'user': (user as UserModel).toJson(),
    };
  }
}

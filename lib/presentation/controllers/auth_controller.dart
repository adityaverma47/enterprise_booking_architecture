import 'package:get/get.dart';
import '../../domain/usecases/auth/login_usecase.dart';
import '../../domain/usecases/auth/register_usecase.dart';
import '../../domain/entities/auth_response.dart';
import '../../core/utils/result.dart';
import '../../core/constants/app_routes.dart';

/// Authentication controller using GetX
class AuthController extends GetxController {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;

  AuthController(this._loginUseCase, this._registerUseCase);

  final _isLoading = false.obs;
  final _errorMessage = ''.obs;
  final _isAuthenticated = false.obs;
  final _currentUser = Rxn<AuthResponse>();

  bool get isLoading => _isLoading.value;
  String? get errorMessage => _errorMessage.value.isEmpty ? null : _errorMessage.value;
  bool get isAuthenticated => _isAuthenticated.value;
  AuthResponse? get currentUser => _currentUser.value;

  Future<void> login(String email, String password) async {
    _isLoading.value = true;
    _errorMessage.value = '';

    final result = await _loginUseCase(email, password);

    result.when(
      success: (authResponse) {
        _currentUser.value = authResponse;
        _isAuthenticated.value = true;
        _navigateToRoleBasedHome(authResponse.user.role);
      },
      failure: (message, _) {
        _errorMessage.value = message;
      },
    );

    _isLoading.value = false;
  }

  Future<void> register({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    _isLoading.value = true;
    _errorMessage.value = '';

    final result = await _registerUseCase(
      email: email,
      password: password,
      name: name,
      role: role,
    );

    result.when(
      success: (authResponse) {
        _currentUser.value = authResponse;
        _isAuthenticated.value = true;
        _navigateToRoleBasedHome(authResponse.user.role);
      },
      failure: (message, _) {
        _errorMessage.value = message;
      },
    );

    _isLoading.value = false;
  }

  void logout() {
    _isAuthenticated.value = false;
    _currentUser.value = null;
    Get.offAllNamed(AppRoutes.login);
  }

  void _navigateToRoleBasedHome(String role) {
    switch (role) {
      case 'user':
        Get.offAllNamed(AppRoutes.userHome);
        break;
      case 'provider':
        Get.offAllNamed(AppRoutes.providerHome);
        break;
      case 'admin':
        Get.offAllNamed(AppRoutes.adminHome);
        break;
      default:
        Get.offAllNamed(AppRoutes.login);
    }
  }
}

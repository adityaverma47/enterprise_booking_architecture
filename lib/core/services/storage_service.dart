import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../logging/app_logger.dart';

/// Abstraction for local storage operations
abstract class StorageService {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> saveRefreshToken(String token);
  Future<String?> getRefreshToken();
  Future<void> saveUserRole(String role);
  Future<String?> getUserRole();
  Future<void> saveUserId(String userId);
  Future<String?> getUserId();
  Future<void> clearAll();
}

class SharedPreferencesStorageService implements StorageService {
  final SharedPreferences _prefs;
  final AppLogger _logger;

  SharedPreferencesStorageService(this._prefs, this._logger);

  @override
  Future<void> saveToken(String token) async {
    await _prefs.setString(AppConstants.tokenKey, token);
    _logger.debug('Token saved');
  }

  @override
  Future<String?> getToken() async {
    return _prefs.getString(AppConstants.tokenKey);
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    await _prefs.setString(AppConstants.refreshTokenKey, token);
  }

  @override
  Future<String?> getRefreshToken() async {
    return _prefs.getString(AppConstants.refreshTokenKey);
  }

  @override
  Future<void> saveUserRole(String role) async {
    await _prefs.setString(AppConstants.userRoleKey, role);
  }

  @override
  Future<String?> getUserRole() async {
    return _prefs.getString(AppConstants.userRoleKey);
  }

  @override
  Future<void> saveUserId(String userId) async {
    await _prefs.setString(AppConstants.userIdKey, userId);
  }

  @override
  Future<String?> getUserId() async {
    return _prefs.getString(AppConstants.userIdKey);
  }

  @override
  Future<void> clearAll() async {
    await _prefs.clear();
    _logger.debug('Storage cleared');
  }
}

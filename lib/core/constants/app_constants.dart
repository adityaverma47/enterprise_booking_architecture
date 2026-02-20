/// Application-wide constants
class AppConstants {
  AppConstants._();

  // API Configuration
  static const String apiVersion = '/api/v1';
  static const int connectionTimeout = 30000; // milliseconds
  static const int receiveTimeout = 30000; // milliseconds

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userRoleKey = 'user_role';
  static const String userIdKey = 'user_id';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Booking Status
  static const String bookingStatusPending = 'pending';
  static const String bookingStatusConfirmed = 'confirmed';
  static const String bookingStatusInProgress = 'in_progress';
  static const String bookingStatusCompleted = 'completed';
  static const String bookingStatusCancelled = 'cancelled';

  // User Roles
  static const String roleUser = 'user';
  static const String roleProvider = 'provider';
  static const String roleAdmin = 'admin';
}

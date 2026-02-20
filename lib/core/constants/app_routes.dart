/// Application route constants
class AppRoutes {
  AppRoutes._();

  // Auth Routes
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // User Routes
  static const String userHome = '/user/home';
  static const String userBookings = '/user/bookings';
  static const String createBooking = '/user/create-booking';
  static const String bookingDetails = '/user/booking-details';

  // Provider Routes
  static const String providerHome = '/provider/home';
  static const String providerBookings = '/provider/bookings';
  static const String providerSchedule = '/provider/schedule';

  // Admin Routes
  static const String adminHome = '/admin/home';
  static const String adminBookings = '/admin/bookings';
  static const String adminUsers = '/admin/users';
  static const String adminProviders = '/admin/providers';
  static const String adminAnalytics = '/admin/analytics';
}

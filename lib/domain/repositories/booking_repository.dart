import '../entities/booking.dart';
import '../../core/utils/result.dart';

/// Booking repository interface
abstract class BookingRepository {
  Future<Result<List<Booking>>> getBookings({
    String? userId,
    String? providerId,
    String? status,
    int page = 1,
    int limit = 20,
  });
  
  Future<Result<Booking>> getBookingById(String bookingId);
  
  Future<Result<Booking>> createBooking({
    required String serviceType,
    required DateTime scheduledAt,
    String? notes,
    String? location,
  });
  
  Future<Result<Booking>> updateBookingStatus(
    String bookingId,
    String status,
  );
  
  Future<Result<Booking>> assignProvider(
    String bookingId,
    String providerId,
  );
  
  Future<Result<void>> cancelBooking(String bookingId);
}

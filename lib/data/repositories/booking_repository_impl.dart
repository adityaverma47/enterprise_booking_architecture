import '../../domain/repositories/booking_repository.dart';
import '../../domain/entities/booking.dart';
import '../../core/utils/result.dart';
import '../datasources/booking_remote_datasource.dart';

/// Booking repository implementation
class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource _remoteDataSource;

  BookingRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<Booking>>> getBookings({
    String? userId,
    String? providerId,
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    final result = await _remoteDataSource.getBookings(
      userId: userId,
      providerId: providerId,
      status: status,
      page: page,
      limit: limit,
    );

    return result.when(
      success: (bookings) => Success(bookings),
      failure: (message, error) => Failure(message, error),
    );
  }

  @override
  Future<Result<Booking>> getBookingById(String bookingId) async {
    final result = await _remoteDataSource.getBookingById(bookingId);

    return result.when(
      success: (booking) => Success(booking),
      failure: (message, error) => Failure(message, error),
    );
  }

  @override
  Future<Result<Booking>> createBooking({
    required String serviceType,
    required DateTime scheduledAt,
    String? notes,
    String? location,
  }) async {
    final result = await _remoteDataSource.createBooking(
      serviceType: serviceType,
      scheduledAt: scheduledAt,
      notes: notes,
      location: location,
    );

    return result.when(
      success: (booking) => Success(booking),
      failure: (message, error) => Failure(message, error),
    );
  }

  @override
  Future<Result<Booking>> updateBookingStatus(
    String bookingId,
    String status,
  ) async {
    final result = await _remoteDataSource.updateBookingStatus(
      bookingId,
      status,
    );

    return result.when(
      success: (booking) => Success(booking),
      failure: (message, error) => Failure(message, error),
    );
  }

  @override
  Future<Result<Booking>> assignProvider(
    String bookingId,
    String providerId,
  ) async {
    final result = await _remoteDataSource.assignProvider(
      bookingId,
      providerId,
    );

    return result.when(
      success: (booking) => Success(booking),
      failure: (message, error) => Failure(message, error),
    );
  }

  @override
  Future<Result<void>> cancelBooking(String bookingId) async {
    final result = await _remoteDataSource.cancelBooking(bookingId);

    return result.when(
      success: (_) => const Success(null),
      failure: (message, error) => Failure(message, error),
    );
  }
}

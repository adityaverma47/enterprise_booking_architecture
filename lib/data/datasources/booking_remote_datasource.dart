import '../../core/network/dio_client.dart';
import '../../core/utils/result.dart';
import '../models/booking_model.dart';

/// Remote data source for bookings
abstract class BookingRemoteDataSource {
  Future<Result<List<BookingModel>>> getBookings({
    String? userId,
    String? providerId,
    String? status,
    int page = 1,
    int limit = 20,
  });
  
  Future<Result<BookingModel>> getBookingById(String bookingId);
  
  Future<Result<BookingModel>> createBooking({
    required String serviceType,
    required DateTime scheduledAt,
    String? notes,
    String? location,
  });
  
  Future<Result<BookingModel>> updateBookingStatus(
    String bookingId,
    String status,
  );
  
  Future<Result<BookingModel>> assignProvider(
    String bookingId,
    String providerId,
  );
  
  Future<Result<void>> cancelBooking(String bookingId);
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final DioClient _client;

  BookingRemoteDataSourceImpl(this._client);

  @override
  Future<Result<List<BookingModel>>> getBookings({
    String? userId,
    String? providerId,
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
    };
    
    if (userId != null) queryParams['user_id'] = userId;
    if (providerId != null) queryParams['provider_id'] = providerId;
    if (status != null) queryParams['status'] = status;

    final result = await _client.get<Map<String, dynamic>>(
      '/bookings',
      queryParameters: queryParams,
      fromJson: (json) => json as Map<String, dynamic>,
    );

    return result.when(
      success: (data) {
        final bookings = (data['data'] as List)
            .map((item) => BookingModel.fromJson(item as Map<String, dynamic>))
            .toList();
        return Success(bookings);
      },
      failure: (message, error) => Failure(message, error),
    );
  }

  @override
  Future<Result<BookingModel>> getBookingById(String bookingId) async {
    final result = await _client.get<Map<String, dynamic>>(
      '/bookings/$bookingId',
      fromJson: (json) => json as Map<String, dynamic>,
    );

    return result.when(
      success: (data) => Success(BookingModel.fromJson(data)),
      failure: (message, error) => Failure(message, error),
    );
  }

  @override
  Future<Result<BookingModel>> createBooking({
    required String serviceType,
    required DateTime scheduledAt,
    String? notes,
    String? location,
  }) async {
    final result = await _client.post<Map<String, dynamic>>(
      '/bookings',
      data: {
        'service_type': serviceType,
        'scheduled_at': scheduledAt.toIso8601String(),
        if (notes != null) 'notes': notes,
        if (location != null) 'location': location,
      },
      fromJson: (json) => json as Map<String, dynamic>,
    );

    return result.when(
      success: (data) => Success(BookingModel.fromJson(data)),
      failure: (message, error) => Failure(message, error),
    );
  }

  @override
  Future<Result<BookingModel>> updateBookingStatus(
    String bookingId,
    String status,
  ) async {
    final result = await _client.put<Map<String, dynamic>>(
      '/bookings/$bookingId/status',
      data: {'status': status},
      fromJson: (json) => json as Map<String, dynamic>,
    );

    return result.when(
      success: (data) => Success(BookingModel.fromJson(data)),
      failure: (message, error) => Failure(message, error),
    );
  }

  @override
  Future<Result<BookingModel>> assignProvider(
    String bookingId,
    String providerId,
  ) async {
    final result = await _client.put<Map<String, dynamic>>(
      '/bookings/$bookingId/assign',
      data: {'provider_id': providerId},
      fromJson: (json) => json as Map<String, dynamic>,
    );

    return result.when(
      success: (data) => Success(BookingModel.fromJson(data)),
      failure: (message, error) => Failure(message, error),
    );
  }

  @override
  Future<Result<void>> cancelBooking(String bookingId) async {
    final result = await _client.delete<void>(
      '/bookings/$bookingId',
    );

    return result.when(
      success: (_) => const Success(null),
      failure: (message, error) => Failure(message, error),
    );
  }
}

import '../../repositories/booking_repository.dart';
import '../../entities/booking.dart';
import '../../../core/utils/result.dart';

/// Get bookings use case
class GetBookingsUseCase {
  final BookingRepository _repository;

  GetBookingsUseCase(this._repository);

  Future<Result<List<Booking>>> call({
    String? userId,
    String? providerId,
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    if (page < 1) {
      return const Failure('Page must be greater than 0');
    }

    if (limit < 1 || limit > 100) {
      return const Failure('Limit must be between 1 and 100');
    }

    return await _repository.getBookings(
      userId: userId,
      providerId: providerId,
      status: status,
      page: page,
      limit: limit,
    );
  }
}

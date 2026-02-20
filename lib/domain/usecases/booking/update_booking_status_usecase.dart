import '../../repositories/booking_repository.dart';
import '../../entities/booking.dart';
import '../../../core/utils/result.dart';
import '../../../core/constants/app_constants.dart';

/// Update booking status use case
class UpdateBookingStatusUseCase {
  final BookingRepository _repository;

  UpdateBookingStatusUseCase(this._repository);

  Future<Result<Booking>> call(String bookingId, String status) async {
    if (bookingId.isEmpty) {
      return const Failure('Booking ID is required');
    }

    final validStatuses = [
      AppConstants.bookingStatusPending,
      AppConstants.bookingStatusConfirmed,
      AppConstants.bookingStatusInProgress,
      AppConstants.bookingStatusCompleted,
      AppConstants.bookingStatusCancelled,
    ];

    if (!validStatuses.contains(status)) {
      return const Failure('Invalid booking status');
    }

    return await _repository.updateBookingStatus(bookingId, status);
  }
}

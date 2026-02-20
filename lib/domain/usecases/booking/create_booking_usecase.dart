import '../../repositories/booking_repository.dart';
import '../../entities/booking.dart';
import '../../../core/utils/result.dart';

/// Create booking use case
class CreateBookingUseCase {
  final BookingRepository _repository;

  CreateBookingUseCase(this._repository);

  Future<Result<Booking>> call({
    required String serviceType,
    required DateTime scheduledAt,
    String? notes,
    String? location,
  }) async {
    if (serviceType.isEmpty) {
      return const Failure('Service type is required');
    }

    if (scheduledAt.isBefore(DateTime.now())) {
      return const Failure('Scheduled time must be in the future');
    }

    return await _repository.createBooking(
      serviceType: serviceType,
      scheduledAt: scheduledAt,
      notes: notes,
      location: location,
    );
  }
}

import 'package:get/get.dart';
import '../../domain/usecases/booking/create_booking_usecase.dart';
import '../../domain/usecases/booking/get_bookings_usecase.dart';
import '../../domain/usecases/booking/update_booking_status_usecase.dart';
import '../../domain/entities/booking.dart';
import '../../core/utils/result.dart';
import '../../core/services/socket_service.dart';

/// Booking controller using GetX
class BookingController extends GetxController {
  final CreateBookingUseCase _createBookingUseCase;
  final GetBookingsUseCase _getBookingsUseCase;
  final UpdateBookingStatusUseCase _updateBookingStatusUseCase;
  final SocketService _socketService;

  BookingController(
    this._createBookingUseCase,
    this._getBookingsUseCase,
    this._updateBookingStatusUseCase,
    this._socketService,
  );

  final _isLoading = false.obs;
  final _errorMessage = ''.obs;
  final _bookings = <Booking>[].obs;
  final _selectedBooking = Rxn<Booking>();

  bool get isLoading => _isLoading.value;
  String? get errorMessage => _errorMessage.value.isEmpty ? null : _errorMessage.value;
  List<Booking> get bookings => _bookings;
  Booking? get selectedBooking => _selectedBooking.value;

  @override
  void onInit() {
    super.onInit();
    _socketService.connect();
    loadBookings();
  }

  @override
  void onClose() {
    _socketService.disconnect();
    super.onClose();
  }

  Future<void> loadBookings({
    String? userId,
    String? providerId,
    String? status,
  }) async {
    _isLoading.value = true;
    _errorMessage.value = '';

    final result = await _getBookingsUseCase(
      userId: userId,
      providerId: providerId,
      status: status,
    );

    result.when(
      success: (bookings) {
        _bookings.value = bookings;
      },
      failure: (message, _) {
        _errorMessage.value = message;
      },
    );

    _isLoading.value = false;
  }

  Future<void> createBooking({
    required String serviceType,
    required DateTime scheduledAt,
    String? notes,
    String? location,
  }) async {
    _isLoading.value = true;
    _errorMessage.value = '';

    final result = await _createBookingUseCase(
      serviceType: serviceType,
      scheduledAt: scheduledAt,
      notes: notes,
      location: location,
    );

    result.when(
      success: (booking) {
        _bookings.insert(0, booking);
        _subscribeToBookingUpdates(booking.id);
        Get.back();
        Get.snackbar('Success', 'Booking created successfully');
      },
      failure: (message, _) {
        _errorMessage.value = message;
        Get.snackbar('Error', message);
      },
    );

    _isLoading.value = false;
  }

  Future<void> updateBookingStatus(String bookingId, String status) async {
    _isLoading.value = true;
    _errorMessage.value = '';

    final result = await _updateBookingStatusUseCase(bookingId, status);

    result.when(
      success: (booking) {
        final index = _bookings.indexWhere((b) => b.id == bookingId);
        if (index != -1) {
          _bookings[index] = booking;
        }
        if (_selectedBooking.value?.id == bookingId) {
          _selectedBooking.value = booking;
        }
        Get.snackbar('Success', 'Booking status updated');
      },
      failure: (message, _) {
        _errorMessage.value = message;
        Get.snackbar('Error', message);
      },
    );

    _isLoading.value = false;
  }

  void selectBooking(Booking booking) {
    _selectedBooking.value = booking;
    _subscribeToBookingUpdates(booking.id);
  }

  void _subscribeToBookingUpdates(String bookingId) {
    _socketService.subscribeToBookingUpdates(
      bookingId,
      (data) {
        // Handle real-time booking update
        final updatedBooking = _bookings.firstWhereOrNull(
          (b) => b.id == bookingId,
        );
        if (updatedBooking != null) {
          loadBookings();
        }
      },
    );
  }
}

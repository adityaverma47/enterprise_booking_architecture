import '../logging/app_logger.dart';

/// Socket service abstraction for real-time updates
/// In Phase 1, this is a mock implementation
abstract class SocketService {
  void connect();
  void disconnect();
  void subscribeToBookingUpdates(String bookingId, Function(Map<String, dynamic>) callback);
  void unsubscribeFromBookingUpdates(String bookingId);
  Stream<Map<String, dynamic>> get bookingUpdates;
}

/// Mock socket service for Phase 1
/// In production, this would connect to a real WebSocket server
class MockSocketService implements SocketService {
  final AppLogger _logger;
  final Map<String, Function(Map<String, dynamic>)> _subscriptions = {};
  bool _isConnected = false;

  MockSocketService(this._logger);

  @override
  void connect() {
    _isConnected = true;
    _logger.info('Mock socket connected');
    // Simulate connection
  }

  @override
  void disconnect() {
    _isConnected = false;
    _subscriptions.clear();
    _logger.info('Mock socket disconnected');
  }

  @override
  void subscribeToBookingUpdates(String bookingId, Function(Map<String, dynamic>) callback) {
    _subscriptions[bookingId] = callback;
    _logger.debug('Subscribed to booking updates: $bookingId');
    
    // Simulate real-time updates (for demo purposes)
    _simulateBookingUpdate(bookingId);
  }

  @override
  void unsubscribeFromBookingUpdates(String bookingId) {
    _subscriptions.remove(bookingId);
    _logger.debug('Unsubscribed from booking updates: $bookingId');
  }

  @override
  Stream<Map<String, dynamic>> get bookingUpdates {
    // Mock stream implementation
    return Stream.periodic(
      const Duration(seconds: 5),
      (count) => {
        'bookingId': 'mock_booking_$count',
        'status': 'updated',
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  void _simulateBookingUpdate(String bookingId) {
    // In a real implementation, this would be triggered by actual socket events
    Future.delayed(const Duration(seconds: 3), () {
      if (_subscriptions.containsKey(bookingId)) {
        _subscriptions[bookingId]!({
          'bookingId': bookingId,
          'status': 'confirmed',
          'message': 'Booking status updated',
          'timestamp': DateTime.now().toIso8601String(),
        });
      }
    });
  }

  /// Simulate receiving a booking update (for testing)
  void simulateBookingUpdate(String bookingId, Map<String, dynamic> data) {
    if (_subscriptions.containsKey(bookingId)) {
      _subscriptions[bookingId]!(data);
    }
  }
}

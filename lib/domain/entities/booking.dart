/// Booking entity - core business entity
class Booking {
  final String id;
  final String userId;
  final String? providerId;
  final String serviceType;
  final DateTime scheduledAt;
  final String status;
  final String? notes;
  final String? location;
  final double? amount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Booking({
    required this.id,
    required this.userId,
    this.providerId,
    required this.serviceType,
    required this.scheduledAt,
    required this.status,
    this.notes,
    this.location,
    this.amount,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isPending => status == 'pending';
  bool get isConfirmed => status == 'confirmed';
  bool get isInProgress => status == 'in_progress';
  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled';
}

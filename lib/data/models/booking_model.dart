import '../../domain/entities/booking.dart';

/// Booking data model
class BookingModel extends Booking {
  const BookingModel({
    required super.id,
    required super.userId,
    super.providerId,
    required super.serviceType,
    required super.scheduledAt,
    required super.status,
    super.notes,
    super.location,
    super.amount,
    required super.createdAt,
    required super.updatedAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      providerId: json['provider_id'] as String?,
      serviceType: json['service_type'] as String,
      scheduledAt: DateTime.parse(json['scheduled_at'] as String),
      status: json['status'] as String,
      notes: json['notes'] as String?,
      location: json['location'] as String?,
      amount: json['amount'] != null ? (json['amount'] as num).toDouble() : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'provider_id': providerId,
      'service_type': serviceType,
      'scheduled_at': scheduledAt.toIso8601String(),
      'status': status,
      'notes': notes,
      'location': location,
      'amount': amount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/booking_controller.dart';
import '../../../../core/utils/date_formatter.dart';

/// Provider home screen
class ProviderHomeScreen extends StatelessWidget {
  const ProviderHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookingController = Get.find<BookingController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Dashboard'),
      ),
      body: Obx(() {
        if (bookingController.isLoading && bookingController.bookings.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (bookingController.bookings.isEmpty) {
          return const Center(
            child: Text('No bookings assigned'),
          );
        }

        return RefreshIndicator(
          onRefresh: () => bookingController.loadBookings(),
          child: ListView.builder(
            itemCount: bookingController.bookings.length,
            itemBuilder: (context, index) {
              final booking = bookingController.bookings[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getStatusColor(booking.status),
                    child: Icon(
                      _getStatusIcon(booking.status),
                      color: Colors.white,
                    ),
                  ),
                  title: Text(booking.serviceType),
                  subtitle: Text(
                    DateFormatter.formatDateTime(booking.scheduledAt),
                  ),
                  trailing: booking.isPending
                      ? ElevatedButton(
                          onPressed: () {
                            bookingController.updateBookingStatus(
                              booking.id,
                              'confirmed',
                            );
                          },
                          child: const Text('Accept'),
                        )
                      : Chip(
                          label: Text(booking.status.toUpperCase()),
                          backgroundColor: _getStatusColor(booking.status),
                        ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'in_progress':
        return Colors.purple;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.pending;
      case 'confirmed':
        return Icons.check_circle;
      case 'in_progress':
        return Icons.work;
      case 'completed':
        return Icons.done_all;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }
}

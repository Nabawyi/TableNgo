// ignore_for_file: deprecated_member_use, non_constant_identifier_names

import 'package:tablengo/data/booking_item.dart';
import 'package:flutter/material.dart';

/// Updated BookingCard widget that works with Supabase booking data
/// This widget displays booking information from the booking_history table
Widget SupabaseBookingCard(BookingItem booking, {int? index}) {
  // Get the actual booking ID from the database
  final bookingId = booking.id;

  // Calculate refund value from the stored refund amount
  final refundValue =
      booking.restaurant.refundAmount; // This will be the refund amount from DB

  return Container(
    padding: const EdgeInsets.all(16.0),
    width: double.infinity,
    height: 250,
    margin: const EdgeInsets.only(bottom: 16.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.0),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              booking.restaurant.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            // Dynamic status badge based on booking status
            Container(
              margin: const EdgeInsets.only(left: 8.0),
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              decoration: BoxDecoration(
                color: _getStatusColor(booking.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                _getStatusText(booking.status),
                style: TextStyle(
                  fontSize: 12,
                  color: _getStatusColor(booking.status),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              color: Colors.grey.shade400,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              booking.restaurant.location,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(10.0),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          height: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Booking ID:',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '#$bookingId',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_month,
                        color: Colors.grey,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${booking.bookingDate.day.toString().padLeft(2, '0')} '
                        '${_monthName(booking.bookingDate.month)}, ${booking.bookingDate.year}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        color: Colors.grey,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        booking.restaurant.time,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.people_alt_outlined,
                        color: Colors.grey,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        booking.restaurant.seatData.isNotEmpty
                            ? booking.restaurant.seatData[booking
                                      .selectedSeatIndex]['seats']
                                  as String
                            : 'N/A',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Deposit: EGP ${_getDepositAmount(booking)}',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Refund on arrival: EGP ${refundValue.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

/// Get the appropriate color for the booking status
Color _getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'pending':
      return Colors.orange;
    case 'completed':
      return Colors.green;
    case 'cancelled':
      return Colors.red;
    case 'confirmed':
      return Colors.blue;
    default:
      return Colors.grey;
  }
}

/// Get the display text for the booking status
String _getStatusText(String status) {
  switch (status.toLowerCase()) {
    case 'pending':
      return 'Pending';
    case 'completed':
      return 'Completed';
    case 'cancelled':
      return 'Cancelled';
    case 'confirmed':
      return 'Confirmed';
    default:
      return 'Unknown';
  }
}

/// Get the deposit amount from booking data
String _getDepositAmount(BookingItem booking) {
  if (booking.restaurant.seatData.isNotEmpty) {
    final seatData = booking.restaurant.seatData[booking.selectedSeatIndex];
    final deposit = seatData['Deposit'] as String? ?? '0';
    return deposit.replaceAll(RegExp(r'[^0-9.]'), '');
  }
  return '0';
}

String _monthName(int month) {
  switch (month) {
    case 1:
      return 'Jan';
    case 2:
      return 'Feb';
    case 3:
      return 'Mar';
    case 4:
      return 'Apr';
    case 5:
      return 'May';
    case 6:
      return 'Jun';
    case 7:
      return 'Jul';
    case 8:
      return 'Aug';
    case 9:
      return 'Sep';
    case 10:
      return 'Oct';
    case 11:
      return 'Nov';
    case 12:
      return 'Dec';
    default:
      return '';
  }
}

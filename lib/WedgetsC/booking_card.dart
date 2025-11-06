import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Widget BookingCard(Map<String, dynamic> bookingData, int index) {
  // Extract values safely from new schema
  final int bookingId = bookingData['id'] ?? 0;
  final String restaurantName = bookingData['restaurant_name'] ?? 'Unknown';
  final String? bookedDateStr = bookingData['booked_date'];
  final String? bookedTimeStr = bookingData['booked_time'];

  final DateTime? bookedDate = bookedDateStr != null
      ? DateTime.tryParse(bookedDateStr)
      : null;
  final int numberOfSeats = bookingData['number_of_seats'] ?? 0;
  final double deposit = (bookingData['deposit'] ?? 0.0).toDouble();
  final double refund = (bookingData['refund'] ?? 0.0).toDouble();
  final double totalPayable = deposit - refund;

  final String status = (bookingData['status'] ?? 'pending')
      .toString()
      .toLowerCase();

  return Container(
    padding: const EdgeInsets.all(16.0),
    width: double.infinity,
    height: 270,
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
        // Restaurant name + status
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              restaurantName,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              decoration: BoxDecoration(
                color: _statusColor(status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                status.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: _statusColor(status),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(10.0),
          width: double.infinity,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Booking ID
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

              // Date + Time + Seats
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Date
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_month,
                        color: Colors.grey,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        bookedDate != null
                            ? '${bookedDate.day.toString().padLeft(2, '0')} ${_monthName(bookedDate.month)}, ${bookedDate.year}'
                            : '—',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  // Time
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        color: Colors.grey,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        bookedTimeStr?.substring(0, 5) ?? '--:--', // Show HH:mm
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  // Seats
                  Row(
                    children: [
                      const Icon(
                        Icons.people_alt_outlined,
                        color: Colors.grey,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        numberOfSeats > 0 ? '$numberOfSeats' : '-',
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Deposit: EGP ${deposit.toStringAsFixed(2)}"),
            Text(
              'Refund on arrival: EGP ${refund.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              "Total Payable: EGP ${totalPayable.toStringAsFixed(2)}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

// Helper: Status color
Color _statusColor(String status) {
  switch (status) {
    case 'completed':
      return Colors.green;
    case 'confirmed':
      return Colors.blue;
    case 'cancelled':
      return Colors.red;
    default:
      return Colors.orange;
  }
}

// Helper: Month name
String _monthName(int month) {
  const months = [
    '',
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return months[month];
}

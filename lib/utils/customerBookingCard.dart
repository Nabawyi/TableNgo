// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Widget BookingCardForCustomers(
  Map<String, dynamic> bookingData,
  int index,
  BuildContext context,
  String status,
  int bookingId,
) {
  // Extract values safely
  final user_Name = bookingData['user_name'] ?? 'Unknown';
  final user_Phone = bookingData['user_phone'] ?? 'Unknown';
  final bookingDate = bookingData['booking_date'] != null
      ? DateTime.parse(bookingData['booking_date'])
      : null;
  final time = bookingData['time'] ?? '--:--';
  final seats = bookingData['seats'] ?? '-';
  final double deposit = (bookingData['deposit'] ?? 0.0).toDouble();
  final double refund = (bookingData['refund'] ?? 0.0).toDouble();
  final double totalPayable = deposit - refund;
  final status = bookingData['status'] ?? 'pending';

  return Container(
    padding: const EdgeInsets.all(16.0),
    width: double.infinity,
    height: 275,
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
              user_Name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            buildStatusChip(context, status, bookingId,(newStatus){
              bookingData['status'] = newStatus;
              (context as Element).markNeedsBuild();
            }),
            // Container(
            //   margin: const EdgeInsets.only(left: 8.0),
            //   padding: const EdgeInsets.symmetric(
            //     horizontal: 8.0,
            //     vertical: 4.0,
            //   ),
            //   decoration: BoxDecoration(
            //     color: () {
            //       switch (status) {
            //         case 'completed':
            //           return Colors.green.shade100;
            //         case 'confirmed':
            //           return Colors.blue.shade100;
            //         case 'cancelled':
            //           return Colors.red.shade100;
            //         default:
            //           return Colors.orange.shade100; // pending
            //       }
            //     }(),
            //     borderRadius: BorderRadius.circular(8.0),
            //   ),
            //   child: Text(
            //     status.toString().toUpperCase(),
            //     style: TextStyle(
            //       fontSize: 12,
            //       fontWeight: FontWeight.bold,
            //       color: () {
            //         switch (status) {
            //           case 'completed':
            //             return Colors.green;
            //           case 'confirmed':
            //             return Colors.blue;
            //           case 'cancelled':
            //             return Colors.red;
            //           default:
            //             return Colors.orange; // pending
            //         }
            //       }(),
            //     ),
            //   ),
            // ),
          ],
        ),

        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.phone_outlined, color: Colors.grey, size: 16),
            const SizedBox(width: 4),
            Text(
              user_Phone,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
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
                    '#${bookingData['id']}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Date + time + seats
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
                        bookingDate != null
                            ? '${bookingDate.day.toString().padLeft(2, '0')} '
                                  '${_monthName(bookingDate.month)}, ${bookingDate.year}'
                            : '—',
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
                        time,
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
                        seats,
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
            Text("Deposit: $deposit"),
            Text(
              'Refund on arrival: EGP $refund',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              "Total Payable: $totalPayable",
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

Widget buildStatusChip(BuildContext context, String status, int bookingId,
  Function(String) onStatusChanged,
) {
  final supabase = Supabase.instance.client;

  Future<void> updateBookingStatus(String newStatus) async {
    await supabase
        .from('booking_history')
        .update({'status': newStatus})
        .eq('id', bookingId);
    onStatusChanged(newStatus);

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Status updated to $newStatus'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black87,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Status styles
  final Map<String, Map<String, dynamic>> statusStyles = {
    'pending': {
      'color': Colors.orange,
      'label': 'Pending',
      'icon': Icons.hourglass_empty_rounded,
    },
    'confirmed': {
      'color': Colors.blue,
      'label': 'Confirmed',
      'icon': Icons.verified_rounded,
    },
    'completed': {
      'color': Colors.green,
      'label': 'Completed',
      'icon': Icons.check_circle_rounded,
    },
    'cancelled': {
      'color': Colors.red,
      'label': 'Cancelled',
      'icon': Icons.cancel_rounded,
    },
  };

  final style = statusStyles[status] ?? statusStyles['pending']!;
  final Color baseColor = style['color'];
  final String label = style['label'];
  final IconData icon = style['icon'];

  return PopupMenuButton<String>(
    tooltip: 'Change status',
    offset: const Offset(0, 40),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    color: Colors.white,
    elevation: 8,
    onSelected: (newStatus) async {
      await updateBookingStatus(newStatus);
    },
    itemBuilder: (context) => statusStyles.entries.map((entry) {
      final isSelected = entry.key == status;
      final color = entry.value['color'] as Color;
      return PopupMenuItem<String>(
        value: entry.key,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          children: [
            Icon(entry.value['icon'], color: color, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                entry.value['label'],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? color : Colors.black87,
                ),
              ),
            ),
            if (isSelected) Icon(Icons.check, color: color, size: 18),
          ],
        ),
      );
    }).toList(),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: baseColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: baseColor.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: baseColor, size: 16),
          const SizedBox(width: 6),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.6,
              color: baseColor,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.keyboard_arrow_down,
            size: 18,
            color: Colors.black54,
          ),
        ],
      ),
    ),
  );
}


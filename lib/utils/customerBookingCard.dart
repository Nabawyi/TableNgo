// customerBookingCard.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Widget BookingCardForCustomers(
  Map<String, dynamic> bookingData,
  int index,
  BuildContext context,
  VoidCallback onRefresh,
) {
  final String userName = bookingData['user_name'] ?? 'Unknown';
  final String userPhone = bookingData['user_phone'] ?? 'Unknown';
  final DateTime? bookedDate = bookingData['booked_date'] != null
      ? DateTime.tryParse(bookingData['booked_date'].toString())
      : null;
  final String time = (bookingData['booked_time'] ?? '--:--')
      .toString()
      .substring(0, 5);
  final int seats = bookingData['number_of_seats'] ?? 0;
  final double deposit = (bookingData['deposit'] ?? 0.0).toDouble();
  final double refund = (bookingData['refund'] ?? 0.0).toDouble();
  final double totalPayable = deposit - refund;
  final String currentStatus = (bookingData['status'] ?? 'pending')
      .toString()
      .toLowerCase();
  final int bookingId = bookingData['id'] as int;
  final String restaurantName = bookingData['restaurant_name'] ?? 'Restaurant';

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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              userName,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            _StatusChip(
              currentStatus: currentStatus,
              bookingId: bookingId,
              onStatusChanged: (newStatus) async {
                await _updateStatus(bookingId, newStatus);
                onRefresh();
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Status → ${newStatus.toUpperCase()}'),
                    backgroundColor: Colors.black87,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ],
        ),

        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.phone_outlined, color: Colors.grey, size: 16),
            const SizedBox(width: 4),
            Text(
              userPhone,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
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
                        '$seats',
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
            Text('Deposit: EGP ${deposit.toStringAsFixed(2)}'),
            Text(
              'Refund on arrival: EGP ${refund.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              'Total Payable: EGP ${totalPayable.toStringAsFixed(2)}',
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

Future<void> _updateStatus(int bookingId, String newStatus) async {
  final supabase = Supabase.instance.client;
  await supabase
      .from('bookings')
      .update({'status': newStatus})
      .eq('id', bookingId);
}

class _StatusChip extends StatelessWidget {
  final String currentStatus;
  final int bookingId;
  final void Function(String) onStatusChanged;

  const _StatusChip({
    required this.currentStatus,
    required this.bookingId,
    required this.onStatusChanged,
  });

  static const List<Map<String, dynamic>> _statusMap = [
    {
      'value': 'pending',
      'label': 'Pending',
      'color': Colors.orange,
      'icon': Icons.hourglass_empty_rounded,
    },
    {
      'value': 'confirmed',
      'label': 'Confirmed',
      'color': Colors.blue,
      'icon': Icons.verified_rounded,
    },
    {
      'value': 'completed',
      'label': 'Completed',
      'color': Colors.green,
      'icon': Icons.check_circle_rounded,
    },
    {
      'value': 'cancelled',
      'label': 'Cancelled',
      'color': Colors.red,
      'icon': Icons.cancel_rounded,
    },
    {
      'value': 'no_show',
      'label': 'No Show',
      'color': Colors.red,
      'icon': Icons.person_off_rounded,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final style = _statusMap.firstWhere(
      (e) => e['value'] == currentStatus,
      orElse: () => _statusMap[0],
    );

    return PopupMenuButton<String>(
      tooltip: 'Change status',
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: Colors.white,
      elevation: 8,
      onSelected: onStatusChanged,
      itemBuilder: (_) => _statusMap.map((entry) {
        final bool selected = entry['value'] == currentStatus;
        final Color c = entry['color'] as Color;
        return PopupMenuItem<String>(
          value: entry['value'] as String,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            children: [
              Icon(entry['icon'] as IconData, color: c, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  entry['label'] as String,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                    color: selected ? c : Colors.black87,
                  ),
                ),
              ),
              if (selected) Icon(Icons.check, color: c, size: 18),
            ],
          ),
        );
      }).toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: (style['color'] as Color).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: (style['color'] as Color).withOpacity(0.25),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              style['icon'] as IconData,
              color: style['color'] as Color,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              (style['label'] as String).toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.6,
                color: style['color'] as Color,
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
}

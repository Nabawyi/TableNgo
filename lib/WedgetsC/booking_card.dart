// userBookingHistoryCard.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: non_constant_identifier_names
Widget BookingCard(Map<String, dynamic> bookingData, int index) {
  return _ExpandableBookingCard(bookingData: bookingData);
}

class _ExpandableBookingCard extends StatefulWidget {
  final Map<String, dynamic> bookingData;

  const _ExpandableBookingCard({required this.bookingData});

  @override
  State<_ExpandableBookingCard> createState() => _ExpandableBookingCardState();
}

class _ExpandableBookingCardState extends State<_ExpandableBookingCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final int bookingId = widget.bookingData['id'] ?? 0;
    final String restaurantName =
        widget.bookingData['restaurant_name'] ?? 'Unknown';
    final String restaurantImage = widget.bookingData['restaurant_image'] ?? '';
    final String location = widget.bookingData['location'] ?? '';

    final String? bookedDateStr = widget.bookingData['booked_date'];
    final DateTime? bookedDate = bookedDateStr != null
        ? DateTime.tryParse(bookedDateStr)
        : null;

    final String? bookedTimeStr = widget.bookingData['booked_time'];
    final String time = _formatTime(bookedTimeStr ?? '00:00:00');
    final String dayName = bookedDate != null
        ? DateFormat('EEE').format(bookedDate)
        : '—';

    final int numberOfSeats = widget.bookingData['number_of_seats'] ?? 0;
    final double deposit = (widget.bookingData['deposit'] ?? 0.0).toDouble();
    final double refund = (widget.bookingData['refund'] ?? 0.0).toDouble();
    final double totalPayable = deposit - refund;

    final String status = (widget.bookingData['status'] ?? 'pending')
        .toString()
        .toLowerCase();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => setState(() => isExpanded = !isExpanded),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Compact Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Restaurant Image/Icon
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [
                          Colors.deepOrange.shade400,
                          Colors.deepOrange.shade600,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepOrange.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: restaurantImage.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              restaurantImage,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(
                            Icons.restaurant,
                            color: Colors.white,
                            size: 30,
                          ),
                  ),

                  const SizedBox(width: 16),

                  // Main Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                restaurantName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _statusColor(status).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: _statusColor(status).withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: _statusColor(status),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    status.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: _statusColor(status),
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              bookedDate != null
                                  ? '$dayName, ${DateFormat('MMM d').format(bookedDate)}'
                                  : '—',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              time,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Expand Icon
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
            ),

            // Expanded Details
            if (isExpanded) ...[
              Divider(color: Colors.grey.shade200, height: 1),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Location (if available)
                    if (location.isNotEmpty) ...[
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.deepOrange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.location_on,
                              size: 16,
                              color: Colors.deepOrange,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              location,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],

                    // Booking Details
                    Row(
                      children: [
                        Expanded(
                          child: _DetailTile(
                            icon: Icons.people_outline,
                            label: 'Seats',
                            value: numberOfSeats.toString(),
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _DetailTile(
                            icon: Icons.confirmation_number_outlined,
                            label: 'Booking ID',
                            value: '#$bookingId',
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Payment Breakdown
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        children: [
                          _PaymentRow(label: 'Deposit', amount: deposit),
                          const SizedBox(height: 8),
                          _PaymentRow(
                            label: 'Refund',
                            amount: -refund,
                            isRefund: true,
                          ),
                          Divider(
                            color: Colors.grey.shade300,
                            height: 16,
                            thickness: 1,
                          ),
                          _PaymentRow(
                            label: 'Total Payable',
                            amount: totalPayable,
                            isBold: true,
                            isTotal: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DetailTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _DetailTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentRow extends StatelessWidget {
  final String label;
  final double amount;
  final bool isBold;
  final bool isRefund;
  final bool isTotal;

  const _PaymentRow({
    required this.label,
    required this.amount,
    this.isBold = false,
    this.isRefund = false,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 14 : 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.deepOrange : Colors.grey.shade700,
          ),
        ),
        Text(
          '${amount < 0 ? '-' : ''}EGP ${amount.abs().toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: isTotal
                ? Colors.deepOrange
                : isRefund
                ? Colors.green
                : Colors.black87,
          ),
        ),
      ],
    );
  }
}

String _formatTime(String rawTime) {
  try {
    final parts = rawTime.split(':');
    if (parts.isEmpty) return rawTime;

    int hour = int.parse(parts[0]);
    final minute = parts.length > 1 ? parts[1] : '00';

    final PM = hour >= 12 ? 'PM' : 'AM';
    if (hour > 12) hour -= 12;
    if (hour == 0) hour = 12;

    return '$hour:$minute $PM';
  } catch (e) {
    return rawTime;
  }
}

Color _statusColor(String status) {
  switch (status) {
    case 'completed':
      return Colors.green;
    case 'confirmed':
      return Colors.blue;
    case 'cancelled':
      return Colors.red;
    case 'no_show':
      return Colors.red.shade700;
    default:
      return Colors.orange;
  }
}

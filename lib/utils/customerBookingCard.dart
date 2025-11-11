// customerBookingCard.dart
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

// ignore: non_constant_identifier_names
Widget BookingCardForCustomers(
  Map<String, dynamic> bookingData,
  int index,
  BuildContext context,
  VoidCallback onRefresh,
) {
  return _ModernBookingCard(bookingData: bookingData, onRefresh: onRefresh);
}

class _ModernBookingCard extends StatefulWidget {
  final Map<String, dynamic> bookingData;
  final VoidCallback onRefresh;

  const _ModernBookingCard({
    required this.bookingData,
    required this.onRefresh,
  });

  @override
  State<_ModernBookingCard> createState() => _ModernBookingCardState();
}

class _ModernBookingCardState extends State<_ModernBookingCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final String restaurantName =
        widget.bookingData['restaurant_name'] ?? 'Unknown';
    final String userName = widget.bookingData['user_name'] ?? 'Unknown';
    final String userPhone = widget.bookingData['user_phone'] ?? 'Unknown';
    final DateTime? bookedDate = widget.bookingData['booked_date'] != null
        ? DateTime.tryParse(widget.bookingData['booked_date'].toString())
        : null;
    final String rawTime = (widget.bookingData['booked_time'] ?? '00:00:00')
        .toString();
    final String time = _formatTime(rawTime);
    final String dayName = bookedDate != null
        ? DateFormat('EEE').format(bookedDate)
        : '—';
    final int seats = widget.bookingData['number_of_seats'] ?? 0;
    final double deposit = (widget.bookingData['deposit'] ?? 0.0).toDouble();
    final double refund = (widget.bookingData['refund'] ?? 0.0).toDouble();
    final double totalPayable = deposit - refund;
    final String currentStatus = (widget.bookingData['status'] ?? 'pending')
        .toString()
        .toLowerCase();
    final int bookingId = widget.bookingData['id'] as int;

    // Check if status can be changed (only pending bookings)
    final bool canChangeStatus = currentStatus == 'pending';
    Future<void> _updateStatus(int bookingId, String newStatus, {required userId, required restaurantName,
    }) async {
      final supabase = Supabase.instance.client;

      await supabase
          .from('bookings')
          .update({'status': newStatus})
          .eq('id', bookingId);

      // 👇 Optional: Send a push notification via Supabase Edge Function
      // await supabase.functions.invoke(
      //   'send-notification',
      //   body: {
      //     'user_id': widget.bookingData['user_id'],
      //     'title': 'Booking ${newStatus.toUpperCase()}',
      //     'message':
      //         'Your booking at ${widget.bookingData['restaurant_name']} '
      //         'has been $newStatus.',
      //   },
      // );
    }
    Future<void> _showConfirmationDialog(
      BuildContext context,
      int bookingId,
      String newStatus,
      String userName,

      VoidCallback onRefresh,
    ) async {
      final bool isConfirming = newStatus == 'confirmed';
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                isConfirming ? Icons.check_circle : Icons.cancel,
                color: isConfirming ? Colors.green : Colors.red,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                isConfirming ? 'Confirm Booking?' : 'Cancel Booking?',
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isConfirming
                    ? 'Are you sure you want to confirm this booking for $userName?'
                    : 'Are you sure you want to cancel this booking for $userName?',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.orange.shade700,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'This action cannot be undone!',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Go Back'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: isConfirming ? Colors.green : Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(isConfirming ? 'Yes, Confirm' : 'Yes, Cancel'),
            ),
          ],
        ),
      );
      if (result == true && context.mounted) {
        try {
          await _updateStatus(
            bookingId,
            newStatus,
            userId: widget.bookingData['user_id'], // 👈 now passed properly
            restaurantName:
                widget.bookingData['restaurant_name'] ?? 'Your Restaurant',
          );
          onRefresh();

          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(
                    isConfirming ? Icons.check_circle : Icons.cancel,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Booking ${isConfirming ? 'confirmed' : 'cancelled'} successfully',
                  ),
                ],
              ),
              backgroundColor: isConfirming ? Colors.green : Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        } catch (e) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to update booking status'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Compact Main Info
          InkWell(
            onTap: () => setState(() => isExpanded = !isExpanded),
            borderRadius: BorderRadius.circular(16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Date Box
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.deepOrange.shade400,
                              Colors.deepOrange.shade600,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.deepOrange.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              dayName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              bookedDate != null
                                  ? bookedDate.day.toString()
                                  : '—',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
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
                                    userName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                _StatusChip(
                                  currentStatus: currentStatus,
                                  canChange: canChangeStatus,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 16,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  time,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Icon(
                                  Icons.people_outline,
                                  size: 16,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '$seats ${seats == 1 ? 'seat' : 'seats'}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Quick Summary
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Payable',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        'EGP ${totalPayable.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Expand/Collapse Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isExpanded ? 'Show less' : 'Show details',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        size: 18,
                        color: Colors.grey.shade600,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Expanded Details
          if (isExpanded)
            Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  Divider(color: Colors.grey.shade200, height: 1),
                  const SizedBox(height: 16),

                  // Booking ID
                  _DetailRow(
                    icon: Icons.confirmation_number_outlined,
                    label: 'Booking ID',
                    value: '#$bookingId',
                  ),

                  const SizedBox(height: 12),

                  // Phone
                  _DetailRow(
                    icon: Icons.phone_outlined,
                    label: 'Phone',
                    value: userPhone,
                  ),

                  const SizedBox(height: 12),

                  // Full Date
                  _DetailRow(
                    icon: Icons.calendar_today_outlined,
                    label: 'Date',
                    value: bookedDate != null
                        ? DateFormat('EEEE, MMMM d, yyyy').format(bookedDate)
                        : '—',
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
                        _PaymentRow(
                          label: 'Deposit',
                          amount: deposit,
                          isBold: false,
                        ),
                        const SizedBox(height: 8),
                        _PaymentRow(
                          label: 'Refund on arrival',
                          amount: -refund,
                          isRefund: true,
                          isBold: false,
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

                  // Action Buttons (only for pending status)
                  if (canChangeStatus) ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _showConfirmationDialog(
                              context,
                              bookingId,
                              'cancelled',
                              userName,
                              widget.onRefresh,
                            ),

                            icon: const Icon(Icons.cancel_outlined, size: 18),
                            label: const Text('Cancel'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _showConfirmationDialog(
                              context,
                              bookingId,
                              'confirmed',
                              userName,
                              widget.onRefresh,
                            ),
                            icon: const Icon(
                              Icons.check_circle_outline,
                              size: 18,
                            ),
                            label: const Text('Confirm'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}



class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
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

    final period = hour >= 12 ? 'PM' : 'AM';
    if (hour > 12) hour -= 12;
    if (hour == 0) hour = 12;

    return '$hour:$minute $period';
  } catch (e) {
    return rawTime;
  }
}
class _StatusChip extends StatelessWidget {
  final String currentStatus;
  final bool canChange;

  const _StatusChip({required this.currentStatus, required this.canChange});

  static const Map<String, Map<String, dynamic>> _statusMap = {
    'pending': {
      'label': 'Pending',
      'color': Colors.orange,
      'icon': Icons.schedule,
    },
    'confirmed': {
      'label': 'Confirmed',
      'color': Colors.blue,
      'icon': Icons.check_circle,
    },
    'completed': {
      'label': 'Completed',
      'color': Colors.green,
      'icon': Icons.done_all,
    },
    'cancelled': {
      'label': 'Cancelled',
      'color': Colors.red,
      'icon': Icons.cancel,
    },
    'no_show': {
      'label': 'No Show',
      'color': Colors.red,
      'icon': Icons.person_off,
    },
  };

  @override
  Widget build(BuildContext context) {
    final style = _statusMap[currentStatus] ?? _statusMap['pending']!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (style['color'] as Color).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: (style['color'] as Color).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            style['icon'] as IconData,
            color: style['color'] as Color,
            size: 12,
          ),
          const SizedBox(width: 4),
          Text(
            (style['label'] as String).toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              color: style['color'] as Color,
            ),
          ),
        ],
      ),
    );
  }
}

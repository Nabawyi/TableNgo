// ignore_for_file: deprecated_member_use

import 'package:tablengo/WedgetsC/supabase_booking_card.dart';
import 'package:tablengo/data/booking_item.dart';
import 'package:tablengo/services/booking_service.dart';
import 'package:flutter/material.dart';

class SupabaseBookingHistory extends StatefulWidget {
  const SupabaseBookingHistory({super.key});

  @override
  State<SupabaseBookingHistory> createState() => _SupabaseBookingHistoryState();
}

class _SupabaseBookingHistoryState extends State<SupabaseBookingHistory> {
  final BookingService _bookingService = BookingService();
  List<BookingItem> _bookings = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  /// Load bookings from Supabase
  Future<void> _loadBookings() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      print('🔵 SupabaseBookingHistory: Loading bookings from Supabase...');

      final bookings = await _bookingService.fetchBookings();

      print('📊 SupabaseBookingHistory: Loaded ${bookings.length} bookings');

      setState(() {
        _bookings = bookings;
        _isLoading = false;
      });
    } catch (e) {
      print('❌ SupabaseBookingHistory: Error loading bookings: $e');
      setState(() {
        _errorMessage = 'Failed to load bookings: $e';
        _isLoading = false;
      });
    }
  }

  /// Refresh bookings (pull-to-refresh)
  Future<void> _refreshBookings() async {
    await _loadBookings();
  }

  /// Update booking status
  Future<void> _updateBookingStatus(int bookingId, String newStatus) async {
    try {
      print(
        '🔵 SupabaseBookingHistory: Updating booking $bookingId to $newStatus',
      );

      final success = await _bookingService.updateStatus(bookingId, newStatus);

      if (success) {
        print('✅ SupabaseBookingHistory: Successfully updated booking status');
        // Refresh the bookings list
        await _loadBookings();

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Booking status updated to $newStatus'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        print('❌ SupabaseBookingHistory: Failed to update booking status');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to update booking status'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print('❌ SupabaseBookingHistory: Error updating booking status: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating booking: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Show status update dialog
  void _showStatusUpdateDialog(BookingItem booking) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Booking Status'),
          content: const Text('Select the new status for this booking:'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _updateBookingStatus(booking.id, 'pending');
              },
              child: const Text('Pending'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _updateBookingStatus(booking.id, 'confirmed');
              },
              child: const Text('Confirmed'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _updateBookingStatus(booking.id, 'completed');
              },
              child: const Text('Completed'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _updateBookingStatus(booking.id, 'cancelled');
              },
              child: const Text('Cancelled'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Bookings',
          style: TextStyle(
            fontSize: 20,
            color: Colors.deepOrange,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.deepOrange),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.deepOrange),
            onPressed: _refreshBookings,
            tooltip: 'Refresh bookings',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange),
            ),
            SizedBox(height: 16),
            Text(
              'Loading bookings...',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error loading bookings',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadBookings,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_bookings.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_note_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No bookings yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Your booking history will appear here',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshBookings,
      color: Colors.deepOrange,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        width: double.infinity,
        child: ListView.builder(
          itemCount: _bookings.length,
          itemBuilder: (context, index) {
            final booking = _bookings[index];
            return GestureDetector(
              onTap: () => _showStatusUpdateDialog(booking),
              child: SupabaseBookingCard(booking, index: index),
            );
          },
        ),
      ),
    );
  }
}

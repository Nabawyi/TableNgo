// Example of how to integrate the Supabase booking system into your existing app

import 'package:tablengo/Screens/supabase_booking_history.dart';
import 'package:tablengo/services/booking_service.dart';
import 'package:tablengo/data/resturant_data.dart';
import 'package:flutter/material.dart';

class ExampleIntegration extends StatefulWidget {
  const ExampleIntegration({super.key});

  @override
  State<ExampleIntegration> createState() => _ExampleIntegrationState();
}

class _ExampleIntegrationState extends State<ExampleIntegration> {
  final BookingService _bookingService = BookingService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Integration Example'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Supabase Booking Integration',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'This example shows how to integrate the Supabase booking system:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),

            // Example 1: Create a test booking
            ElevatedButton(
              onPressed: _createTestBooking,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
              child: const Text(
                'Create Test Booking',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),

            // Example 2: View booking history
            ElevatedButton(
              onPressed: _viewBookingHistory,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
              child: const Text(
                'View Booking History',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),

            // Example 3: Fetch and display bookings
            ElevatedButton(
              onPressed: _fetchBookings,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
              child: const Text(
                'Fetch Bookings from Database',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Instructions:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '1. First, run the SQL script in Supabase\n'
              '2. Click "Create Test Booking" to add sample data\n'
              '3. Click "View Booking History" to see the Supabase UI\n'
              '4. Click "Fetch Bookings" to see debug output',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  /// Create a test booking to demonstrate the system
  Future<void> _createTestBooking() async {
    try {
      // Create a sample restaurant data
      final restaurant = ResturantData(
        id: 1,
        name: 'Sample Restaurant',
        image: 'https://example.com/restaurant.jpg',
        location: 'Downtown Location',
        time: '7:00 PM',
        rating: 4.5,
        refundAmount: 20.0, // 20% refund
        seatData: [
          {'seats': 'Table for 2', 'time': '7:00 PM', 'Deposit': 'EGP 50'},
          {'seats': 'Table for 4', 'time': '8:00 PM', 'Deposit': 'EGP 75'},
        ],
      );

      // Create the booking
      final bookingId = await _bookingService.addBooking(
        restaurant,
        0, // First seat option
        DateTime.now().add(const Duration(days: 1)),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Test booking created with ID: $bookingId'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating booking: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Navigate to the Supabase booking history screen
  void _viewBookingHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SupabaseBookingHistory()),
    );
  }

  /// Fetch bookings and show debug information
  Future<void> _fetchBookings() async {
    try {
      final bookings = await _bookingService.fetchBookings();

      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Bookings from Database'),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookings[index];
                    return ListTile(
                      title: Text(booking.restaurant.name),
                      subtitle: Text('Status: ${booking.status}'),
                      trailing: Text('ID: ${booking.id}'),
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error fetching bookings: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

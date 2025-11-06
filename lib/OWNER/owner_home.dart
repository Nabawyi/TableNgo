// owner_home.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tablengo/Screens/Welcome_screen.dart';
import 'package:tablengo/utils/customerBookingCard.dart';

class OwnerHome extends StatefulWidget {
  final int restaurantId;

  const OwnerHome({super.key, required this.restaurantId});

  @override
  State<OwnerHome> createState() => _OwnerHomeState();
}

class _OwnerHomeState extends State<OwnerHome> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> customerBookingData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

  /// Fetch bookings with restaurant name joined
  Future<void> fetchBookings() async {
    setState(() => isLoading = true);
    try {
      final response = await supabase
          .from('bookings')
          .select('''
            id, user_name, user_phone, booked_date, booked_time,
            number_of_seats, deposit, refund, total_payable, status,
            restaurant:restaurant_id (name)
          ''')
          .eq('restaurant_id', widget.restaurantId)
          .order('id', ascending: false);

      setState(() {
        customerBookingData = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching bookings: $e');
      setState(() => isLoading = false);
    }
  }

  /// Update status
  Future<void> updateBookingStatus(int bookingId, String newStatus) async {
    try {
      await supabase
          .from('bookings')
          .update({'status': newStatus})
          .eq('id', bookingId);

      await fetchBookings();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Update failed: $e'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/Logo_orange.png', height: 50),
        centerTitle: true,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(
              Icons.manage_accounts,
              color: Colors.deepOrange,
              size: 30,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () =>
                Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                  (route) => false,
                ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : customerBookingData.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_busy, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No bookings yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: fetchBookings,
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: customerBookingData.length,
                itemBuilder: (context, index) {
                  final booking = customerBookingData[index];
                  final restaurantName =
                      (booking['restaurant'] as Map?)?['name'] ??
                      'Unknown Restaurant';

                  final displayBooking = Map<String, dynamic>.from(booking)
                    ..['restaurant_name'] = restaurantName;

                  return BookingCardForCustomers(
                    displayBooking,
                    index,
                    context,
                    fetchBookings,
                  );
                },
              ),
            ),
    );
  }
}

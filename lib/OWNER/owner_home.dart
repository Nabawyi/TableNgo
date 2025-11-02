import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tablengo/utils/customerBookingCard.dart';

class OwnerHome extends StatefulWidget {
  final int restaurantId; // Pass the restaurant ID of the owner

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

  /// ✅ Fetch all bookings for this restaurant
  Future<void> fetchBookings() async {
    try {
      final response = await supabase
          .from('booking_history')
          .select()
          .eq('restaurant_id', widget.restaurantId)
          .order('id', ascending: false);

      setState(() {
        customerBookingData = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching bookings: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // ✅ Update the Status
  Future<void> updateBookingStatus(int bookingId, String newStatus) async {
    try {
      await supabase
          .from('booking_history')
          .update({'status': newStatus})
          .eq('id', bookingId);

      // Optional: refresh bookings after update
      await fetchBookings();
    } catch (e) {
      print('Error updating status: $e');
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
          builder: (context) {
            return IconButton(
              icon: const Icon(
                Icons.manage_accounts,
                color: Colors.deepOrange,
                size: 30,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : customerBookingData.isEmpty
          ? const Center(child: Text('No bookings yet'))
          : RefreshIndicator(
            onRefresh: fetchBookings,
            child: ListView.builder(
                itemCount: customerBookingData.length,
                itemBuilder: (context, index) {
                  final booking = customerBookingData[index];
            
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BookingCardForCustomers(
                      booking,
                      index,
                      context,
                      booking['status'],
                      booking['id'],
                    ),
                  );
                },
              ),
          ),
    );
  }
}

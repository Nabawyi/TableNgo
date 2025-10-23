import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tablengo/data/resturant_data.dart';
import 'package:tablengo/data/booking_item.dart';

class BookingService {
  final supabase = Supabase.instance.client;

  /// Add a new booking to the booking_history table
  ///
  /// Parameters:
  /// - restaurant: The restaurant data containing id, name, image
  /// - seatIndex: The selected seat index
  /// - bookingDate: The date and time of the booking
  ///
  /// Returns: The created booking ID
  Future<int> addBooking(
    ResturantData restaurant,
    int seatIndex,
    DateTime bookingDate,
  ) async {
    try {
      print(
        '🔵 BookingService: Adding booking for restaurant ${restaurant.name}',
      );

      // Get seat data for the selected seat
      final seatData = restaurant.seatData[seatIndex];
      final seats = seatData['seats'] ?? '';
      final time = seatData['time'] ?? '';
      final depositStr = seatData['Deposit'] ?? '0';
      final user = supabase.auth.currentUser;

      // Parse deposit amount
      final deposit =
          double.tryParse(
            depositStr.toString().replaceAll(RegExp(r'[^0-9.]'), ''),
          ) ??
          0.0;

      // Calculate refund amount
      final refund = deposit * (restaurant.refundAmount / 100);

      final response = await supabase
          .from('booking_history')
          .insert({
            'restaurant_name': restaurant.name,
            'restaurant_image': restaurant.image,
            'location': restaurant.location,
            'seat_index': seatIndex,
            'booking_date': bookingDate.toIso8601String(),
            'time': time,
            'seats': seats,
            'deposit': deposit,
            'refund': refund,
            'user_id': user!.id, 
            // status will default to 'pending' from database
          })
          .select('id');

      final bookingId = response.first['id'] as int;
      print('✅ BookingService: Successfully added booking with ID: $bookingId');

      return bookingId;
    } catch (e) {
      print('❌ BookingService: Error adding booking: $e');
      rethrow;
    }
  }

  /// Fetch all bookings from the booking_history table
  ///
  /// Returns: List of BookingItem objects ordered by booking_date desc
  Future<List<BookingItem>> fetchBookings() async {
          final user = supabase.auth.currentUser;

    try {
      print('🔵 BookingService: Fetching all bookings');

      final response = await supabase
          .from('booking_history')
          .select('*')
          .eq('user_id',user!.id, )
          .order('booking_date', ascending: false);

      print('📊 BookingService: Found ${response.length} bookings');

      final List<BookingItem> bookings = [];

      for (final row in response) {
        try {
          // Create a ResturantData object from the stored restaurant data
          final restaurant = ResturantData(
            id: null, // No restaurant_id in new structure
            name: row['restaurant_name'] as String,
            image: row['restaurant_image'] as String? ?? '',
            location: row['location'] as String? ?? '',
            time: row['time'] as String? ?? '',
            rating: 0.0, // Not stored in booking_history
            refundAmount: 0.0, // Not stored in booking_history
            seatData: [], // Not stored in booking_history
          );

          final booking = BookingItem.fromJson(row, restaurant);
          bookings.add(booking);
        } catch (e) {
          print('⚠️ BookingService: Error parsing booking row: $e');
          continue;
        }
      }

      print(
        '✅ BookingService: Successfully fetched ${bookings.length} bookings',
      );
      return bookings;
    } catch (e) {
      print('❌ BookingService: Error fetching bookings: $e');
      rethrow;
    }
  }

  /// Update the status of a booking
  ///
  /// Parameters:
  /// - id: The booking ID to update
  /// - newStatus: The new status (e.g., 'pending', 'completed', 'cancelled')
  ///
  /// Returns: True if successful, false otherwise
  Future<bool> updateStatus(int id, String newStatus) async {
    try {
      print('🔵 BookingService: Updating booking $id status to $newStatus');

      await supabase
          .from('booking_history')
          .update({'status': newStatus})
          .eq('id', id);

      print(
        '✅ BookingService: Successfully updated booking $id status to $newStatus',
      );
      return true;
    } catch (e) {
      print('❌ BookingService: Error updating booking status: $e');
      return false;
    }
  }

  /// Get a specific booking by ID
  ///
  /// Parameters:
  /// - id: The booking ID to fetch
  ///
  /// Returns: BookingItem if found, null otherwise
  Future<BookingItem?> getBookingById(int id) async {
    try {
      print('🔵 BookingService: Fetching booking with ID: $id');

      final response = await supabase
          .from('booking_history')
          .select('*')
          .eq('id', id)
          .single();

      // Create a ResturantData object from the stored restaurant data
      final restaurant = ResturantData(
        id: null, // No restaurant_id in new structure
        name: response['restaurant_name'] as String,
        image: response['restaurant_image'] as String? ?? '',
        location: response['location'] as String? ?? '',
        time: response['time'] as String? ?? '',
        rating: 0.0, // Not stored in booking_history
        refundAmount: 0.0, // Not stored in booking_history
        seatData: [], // Not stored in booking_history
      );

      final booking = BookingItem.fromJson(response, restaurant);
      print('✅ BookingService: Successfully fetched booking $id');
      return booking;
    } catch (e) {
      print('❌ BookingService: Error fetching booking $id: $e');
      return null;
    }
  }

  /// Delete a booking by ID
  ///
  /// Parameters:
  /// - id: The booking ID to delete
  ///
  /// Returns: True if successful, false otherwise
  Future<bool> deleteBooking(int id) async {
    try {
      print('🔵 BookingService: Deleting booking with ID: $id');

      await supabase.from('booking_history').delete().eq('id', id);

      print('✅ BookingService: Successfully deleted booking $id');
      return true;
    } catch (e) {
      print('❌ BookingService: Error deleting booking $id: $e');
      return false;
    }
  }
}

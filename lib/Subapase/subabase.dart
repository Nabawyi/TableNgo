import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tablengo/data/resturant_data.dart';
import 'package:tablengo/data/booking_item.dart';
import 'dart:convert';

class SupabaseService {
  final supabase = Supabase.instance.client;

  Future<List<ResturantData>> fetchRestaurants() async {
    try {
      final data = await supabase
          .from('restaurants')
          .select(
            'id, name, image, location, time, rating, refund_amount, seat_data',
          );
      final List<dynamic> rows = data as List<dynamic>;

      return rows.map<ResturantData>((row) {
        // Ensure Map<String, dynamic>
        final map = Map<String, dynamic>.from(row as Map);

        // Normalize potential snake_case keys to those expected by model
        // Model already reads: image/location/time/rating/refund_amount/seat_data
        // Just ensure seat_data is a List<Map<String, dynamic>>; decode if string
        final seat = map['seat_data'];
        if (seat is String) {
          try {
            final decoded = jsonDecode(seat);
            if (decoded is List) {
              map['seat_data'] = decoded;
            }
          } catch (_) {}
        }
        // Fallback aliasing
        map['refund_amount'] = map['refund_amount'] ?? map['refundAmount'];
        map['image'] = map['image'] ?? map['image_url'];
        map['seat_data'] = map['seat_data'] ?? map['seatData'];

        return ResturantData.fromJson(map);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> addRestaurant(ResturantData restaurant) async {
    await supabase.from('restaurants').insert(restaurant.toJson());
  }

  // Booking-related methods (delegated to BookingService for better organization)
  // These methods are kept here for backward compatibility but should use BookingService instead

  /// Add a new booking to the booking_history table
  Future<int> addBooking(
    ResturantData restaurant,
    int seatIndex,
    DateTime bookingDate,
  ) async {
    try {
      print(
        '🔵 SupabaseService: Adding booking for restaurant ${restaurant.name}',
      );

      // Get seat data for the selected seat
      final seatData = restaurant.seatData[seatIndex];
      final seats = seatData['seats'] ?? '';
      final time = seatData['time'] ?? '';
      final depositStr = seatData['Deposit'] ?? '0';

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
            // status will default to 'pending' from database
          })
          .select('id');

      final bookingId = response.first['id'] as int;
      print(
        '✅ SupabaseService: Successfully added booking with ID: $bookingId',
      );

      return bookingId;
    } catch (e) {
      print('❌ SupabaseService: Error adding booking: $e');
      rethrow;
    }
  }

  /// Fetch all bookings from the booking_history table
  Future<List<BookingItem>> fetchBookings() async {
    try {
      print('🔵 SupabaseService: Fetching all bookings');

      final response = await supabase
          .from('booking_history')
          .select('*')
          .order('booking_date', ascending: false);

      print('📊 SupabaseService: Found ${response.length} bookings');

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
          print('⚠️ SupabaseService: Error parsing booking row: $e');
          continue;
        }
      }

      print(
        '✅ SupabaseService: Successfully fetched ${bookings.length} bookings',
      );
      return bookings;
    } catch (e) {
      print('❌ SupabaseService: Error fetching bookings: $e');
      rethrow;
    }
  }

  /// Update the status of a booking
  Future<bool> updateStatus(int id, String newStatus) async {
    try {
      print('🔵 SupabaseService: Updating booking $id status to $newStatus');

      await supabase
          .from('booking_history')
          .update({'status': newStatus})
          .eq('id', id);

      print(
        '✅ SupabaseService: Successfully updated booking $id status to $newStatus',
      );
      return true;
    } catch (e) {
      print('❌ SupabaseService: Error updating booking status: $e');
      return false;
    }
  }
}

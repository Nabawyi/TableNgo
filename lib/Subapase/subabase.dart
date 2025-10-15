import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:TableNgo/data/resturant_data.dart';
import 'dart:convert';

class SupabaseService {
  final supabase = Supabase.instance.client;

  Future<List<ResturantData>> fetchRestaurants() async {
    try {
      final data = await supabase.from('restaurants').select(
          'id, name, image, location, time, rating, refund_amount, seat_data'
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
}

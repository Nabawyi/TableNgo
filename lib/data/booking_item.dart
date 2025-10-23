import 'package:tablengo/data/resturant_data.dart';

class BookingItem {
  final int id; // database primary key
  final ResturantData restaurant; // your class
  final int selectedSeatIndex;
  final DateTime bookingDate;
  final String status; // e.g., “pending”, “completed”, “cancelled”

  BookingItem({
    required this.id,
    required this.restaurant,
    required this.selectedSeatIndex,
    required this.bookingDate,
    required this.status,
  });

  factory BookingItem.fromJson(
    Map<String, dynamic> json,
    ResturantData restaurant,
  ) {
    return BookingItem(
      id: json['id'] as int,
      restaurant: restaurant,
      selectedSeatIndex: json['seat_index'] as int,
      bookingDate: DateTime.parse(json['booking_date'] as String),
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'restaurant_id': restaurant.id, // assuming you store restaurant ID
      'seat_index': selectedSeatIndex,
      'booking_date': bookingDate.toIso8601String(),
      'status': status,
    };
  }
}
